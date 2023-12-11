
string xmlString = "";

bool isMapLoaded = false;

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

    auto fidFile = cast<CSystemFidFile>(GetApp().RootMap);
    if (fidFile is null) { 
        isMapLoaded = false;
        return;
    }
    
    if (!isMapLoaded) {
        auto fileName = fidFile.FullFileName;
            print("aaa" + fileName);

        OnMapLoad(fidFile, fileName);
        isMapLoaded = true;
    }
}

void OnMapLoad(auto fidFile, auto fileName) {
    string exeVersion = GetExeVersionFromXML(fidFile, fileName);
    
    
    if (exeVersion < "1.0.0")
    {
        NotifyWarn("Exe version is below the required version.");
    }
}

string GetExeVersionFromXML(auto fidFile, auto fileName) {
    string exeVersion = "";
    
    if (fidFile !is null)
    {
        try
        {   
            print("aaa" + fileName);
            IO::File mapFile(fileName);
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
            
            int exeverStart = xmlString.Find("exever=\"") + 8;
            int exeverEnd = xmlString.Find("\"", exeverStart);
            exeVersion = xmlString.SubString(exeverStart, exeverEnd - exeverStart);
        }
        catch
        {
            error("Error while reading GBX XML Header");
        }
    }
    
    return exeVersion;
}


// Notification

void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Auto Load WR Ghost", msg, vec4(1, .5, .1, .5), 10000);
}
