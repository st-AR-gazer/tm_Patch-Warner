
string xmlString = "";

auto fidFile;

bool isMapLoaded = false;

void Main() {
    print("Test");

    while (true) {
        Update();
        sleep(500);
    }
}

void Update() {
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    if (app is null) return;

    auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
    if (playground is null || playground.Arena.Players.Length == 0) {
        isMapLoaded = false;
        return;
    }

    auto script = cast<CSmScriptPlayer>(playground.Arena.Players[0].ScriptAPI);
    if (script is null) return; 

    auto scene = cast<ISceneVis@>(app.GameScene);
    if (scene is null) return;

    CGameCtnEditorFree@ Editor = cast<CGameCtnEditorFree>(GetApp().Editor);
    if (Editor is null) return;

    CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetFidFromNod(Editor.Challenge));
    if (fidFile is null) { 
        isMapLoaded = false;
        return;
    }


    print("aaa " + fidFile.FullFileName);
    
    if (!isMapLoaded) {
        OnMapLoad(fidFile);
        isMapLoaded = true;
    }
}

void OnMapLoad(CSystemFidFile fidFile) {
    string exeVersion = GetExeVersionFromXML(fidFile);
    
    if (exeVersion < "3.3.0")
    {
        NotifyWarn("This maps exe version: '" + exeVersion + "'' indicates that this map was uploaded BEFORE the wood update, all wood on this map wil behave like tarmac (road).");
    }
}

class GbxHeaderChunkInfo
{
    int ChunkId;
    int ChunkSize;
}

string GetExeVersionFromXML(CSystemFidFile fidFile) {
    string xmlString = "";
    if (fidFile !is null)
    {
        try
        {
            IO::File mapFile(fidFile.FullFileName);
            mapFile.Open(IO::FileMode::Read);

            mapFile.SetPos(17);
            int headerChunkCount = mapFile.Read(4).ReadInt32();

            GbxHeaderChunkInfo[] chunks = {};
            for (int i = 0; i < headerChunkCount; i++)
            {
                GbxHeaderChunkInfo newChunk;
                newChunk.ChunkId = mapFile.Read(4).ReadInt32();
                newChunk.ChunkSize = mapFile.Read(4).ReadInt32() & 0x7FFFFFFF;
                chunks.InsertLast(newChunk);
            }

            for (uint i = 0; i < chunks.Length; i++)
            {
                MemoryBuffer chunkBuffer = mapFile.Read(chunks[i].ChunkSize);
                if (chunks[i].ChunkId == 50606085)
                {
                    int stringLength = chunkBuffer.ReadInt32();
                    xmlString = chunkBuffer.ReadString(stringLength);
                    break;
                }
            }

            mapFile.Close();
        }
        catch
        {
            error("Error while reading GBX XML Header");
        }
    }
    return xmlString;
}



// Notification

void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Map date warning", msg, vec4(1, .5, .1, .5), 10000);
}