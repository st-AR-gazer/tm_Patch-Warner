class GbxHeaderChunkInfo
{
    int ChunkId;
    int ChunkSize;
}

string GetExeBuildFromXML() {
    
    [Setting category="General" name="Use Offset" description="Use some offset instead of the map files XML to get the exe build."]
    bool doOffsetXML = false;
    if (doOffsetXML) return Dev::GetOffsetString(GetApp().RootMap, 0x78);

    string xmlString = "";
    string exeBuild = "";

    log("GetExeBuildFromXML function started.", LogLevel::Info, 11);

    CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetApp().RootMap.MapInfo.Fid);

    if (fidFile !is null) {
        try {
            log("Opening map file.", LogLevel::Info, 17);

            IO::File mapFile(fidFile.FullFileName);
            mapFile.Open(IO::FileMode::Read);

            mapFile.SetPos(17);
            int headerChunkCount = mapFile.Read(4).ReadInt32();
            
            log("Header chunk count: " + headerChunkCount, LogLevel::Info, 25);

            GbxHeaderChunkInfo[] chunks = {};
            for (int i = 0; i < headerChunkCount; i++) {
                GbxHeaderChunkInfo newChunk;
                newChunk.ChunkId = mapFile.Read(4).ReadInt32();
                newChunk.ChunkSize = mapFile.Read(4).ReadInt32() & 0x7FFFFFFF;
                chunks.InsertLast(newChunk);
                
                log("Read chunk " + i + " with id " + newChunk.ChunkId + " and size " + newChunk.ChunkSize, LogLevel::Info, 34);
            }

            for (uint i = 0; i < chunks.Length; i++) {
                MemoryBuffer chunkBuffer = mapFile.Read(chunks[i].ChunkSize);
                if (chunks[i].ChunkId == 50606085) {
                    int stringLength = chunkBuffer.ReadInt32();
                    xmlString = chunkBuffer.ReadString(stringLength);
                    break;
                }

                log("Read chunk " + i + " of size " + chunks[i].ChunkSize, LogLevel::Info, 45);
            }

            mapFile.Close();

            if (xmlString != "") {
                XML::Document doc;
                doc.LoadString(xmlString);
                XML::Node headerNode = doc.Root().FirstChild();
                
                if (headerNode) {
                    string potentialExeBuild = headerNode.Attribute("exebuild");
                    if (potentialExeBuild != "") {
                        exeBuild = potentialExeBuild;
                    } else {
                        log("Exe build not found in XML. Assuming a new map.", LogLevel::Warn, 60);
                        return "9999-99-99_99_99";
                    }
                } else {
                    log("headerNode is invalid in GetExeBuildFromXML.", LogLevel::Warn, 64);
                }
            }
            log("GetExeBuildFromXML function finished.", LogLevel::Info, 67);
        }
        catch {
            log("Error reading map file in GetExeBuildFromXML.", LogLevel::Error, 70);
        }
    }
    else {
        log("fidFile is null in GetExeBuildFromXML.", LogLevel::Warn, 74);
    }
    return exeBuild;
}