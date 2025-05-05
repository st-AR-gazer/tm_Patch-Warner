namespace Detectors {

    class GbxHeaderChunkInfo { int ChunkId; int ChunkSize; }

    [Setting category="General" name="Use Offset" description="DEV: Read exeBuild via fixed GBX offset instead of XML chunk"]
    bool S_useOffset = false;

    string GetExeBuild() {
        string raw;

        if (S_useOffset) {
            raw = Dev::GetOffsetString(GetApp().RootMap, 0x78);
        } else {
            raw = ReadExeBuildFromXmlChunk();
        }

        return Normalize(raw);
    }


    string Normalize(const string &in s) {
        if (s == "") return "";

        array<string> parts = s.Split("_");
        if (parts.Length < 2) return s;

        string datePart = parts[0];

        array<string> t = parts;
        t.RemoveAt(0);
        while (t.Length < 3) t.InsertLast("00");

        string timePart = t[0] + "-" + t[1] + "-" + t[2];
        return datePart + "_" + timePart;
    }


    string ReadExeBuildFromXmlChunk() {

        string xmlString, exeBuild;

        log("GetExeBuild() started.", LogLevel::Info, 36, "BuildDetector");

        CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetApp().RootMap.MapInfo.Fid);
        if (fidFile is null) {
            log("fidFile null.", LogLevel::Warn, 39, "BuildDetector");
            return "";
        }

        try {
            IO::File mapFile(fidFile.FullFileName);
            mapFile.Open(IO::FileMode::Read);

            mapFile.SetPos(17);
            int hdrCount = mapFile.Read(4).ReadInt32();

            GbxHeaderChunkInfo[] chunks;
            for (int i = 0; i < hdrCount; ++i) {
                GbxHeaderChunkInfo ch;
                ch.ChunkId   = mapFile.Read(4).ReadInt32();
                ch.ChunkSize = mapFile.Read(4).ReadInt32() & 0x7FFFFFFF;
                chunks.InsertLast(ch);
            }

            for (uint i = 0; i < chunks.Length; ++i) {
                MemoryBuffer buf = mapFile.Read(chunks[i].ChunkSize);
                if (chunks[i].ChunkId == 50606085) {           // header XML chunk
                    int strLen = buf.ReadInt32();
                    xmlString  = buf.ReadString(strLen);
                    break;
                }
            }
            mapFile.Close();

            if (xmlString != "") {
                XML::Document doc; doc.LoadString(xmlString);
                XML::Node hdr = doc.Root().FirstChild();
                if (hdr) exeBuild = hdr.Attribute("exebuild");
            }

        } catch {
            log("Error reading GBX.", LogLevel::Error, 67, "BuildDetector");
        }

        return exeBuild;
    }

}
