
string xmlString = "";
auto fidFile;

bool isMapLoaded = false;

void Main() {
    while (true) {
        Update();
        sleep(500);
        print("aaa");
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

    print("aaaaaaaaaaaaaaa");

    CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetFidFromNod(app.RootMap.MapInfo.Fid));
    if (fidFile is null) { 
        isMapLoaded = false;
        return;
    }

    print("bbbbbbbbbbbbbbbb");

    if (!isMapLoaded) {
        log("Map load check started...", LogLevel::Info);
        OnMapLoad();
        isMapLoaded = true;
        log("Map load check completed.", LogLevel::Info);
    }
}





void OnMapLoad() {
    log("OnMapLoad function started.", LogLevel::Info);
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetFidFromNod(app.RootMap.MapInfo.Fid));

    string exeBuild = GetExeBuildFromXML(fidFile);
    log("Exe build: " + exeBuild, LogLevel::Info);

    if (exeBuild < "2022-05-19_15_03") {
        log("The exebuild is less than 2022-05-19_15_03. Warning ice physics-1.", LogLevel::Warn);
        NotifyWarnIce("This map's exeBuild: '" + exeBuild + "' indicates that it was uploaded BEFORE the first ice update, the medal times may be affected.");
    } else if (exeBuild >= "2023-04-28_17_34" && exeBuild < "2023-11-15_11_56") {
        log("The exebuild falls between 2023-04-28_17_34 and 2023-11-15_11_56. Warning ice physics-2.", LogLevel::Warn);
        NotifyWarnIce2("This map's exeBuild: '" + exeBuild + "' falls BETWEEN the two ice updates, the medal times may be affected.");
    }
    
    if (exeBuild < "2023-04-28_17_34")
    {
        log("The exebuild is less than 2023-04-28_17_34. Warning wood physics.", LogLevel::Warn);
        NotifyWarn("This maps exeVer: '" + exeBuild + "' indicates that this map was uploaded BEFORE the wood update, all wood on this map will behave like tarmac (road).");
    }
    log("OnMapLoad function finished.", LogLevel::Info);
}

class GbxHeaderChunkInfo
{
    int ChunkId;
    int ChunkSize;
}

string GetExeBuildFromXML(CSystemFidFile@ fidFile) {
    log("GetExeBuildFromXML function started.", LogLevel::Info);
    if (fidFile !is null)
    {
        try
        {
            log("Opening map file.", LogLevel::Info);
            IO::File mapFile(fidFile.FullFileName);
            mapFile.Open(IO::FileMode::Read);

            mapFile.SetPos(17);
            int headerChunkCount = mapFile.Read(4).ReadInt32();
            log("Header chunk count: " + headerChunkCount, LogLevel::Info);

            GbxHeaderChunkInfo[] chunks = {};
            for (int i = 0; i < headerChunkCount; i++)
            {
                GbxHeaderChunkInfo newChunk;
                newChunk.ChunkId = mapFile.Read(4).ReadInt32();
                newChunk.ChunkSize = mapFile.Read(4).ReadInt32() & 0x7FFFFFFF;
                chunks.InsertLast(newChunk);
                log("Read chunk " + i + " with id " + newChunk.ChunkId + " and size " + newChunk.ChunkSize, LogLevel::Info);
            }

            for (uint i = 0; i < chunks.Length; i++)
            {
                MemoryBuffer chunkBuffer = mapFile.Read(chunks[i].ChunkSize);
                log("Read chunk " + i + " of size " + chunks[i].ChunkSize, LogLevel::Info);
            }
            log("GetExeBuildFromXML function finished.", LogLevel::Info);
        }
        catch
        {
            log("Error reading map file in GetExeBuildFromXML.", LogLevel::Error);
        }
    }
    else
    {
        log("fidFile is null in GetExeBuildFromXML.", LogLevel::Warn);
    }
    return xmlString;
}