
string xmlString = "";
auto fidFile = cast<CSystemFidFile>(GetFidFromNod(Editor.Challenge));


void OnMapLoad() {
    string exeVersion = GetExeVersionFromXML();
    
    if (exeVersion < "1.0.0")
    {
        NotifyWarn("Exe version is below the required version.");
    }
}

string GetExeVersionFromXML() {
    string exeVersion = "";
    
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
