namespace Detectors {

    class GbxHeaderChunkInfo { int ChunkId; int ChunkSize; }

    [Setting hidden]
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

        string t = s;
        int spaceIdx = t.IndexOf(" ");
        if (spaceIdx >= 0) t = t.SubStr(0, spaceIdx);
        const string prefix = "date=";
        if (t.StartsWith(prefix)) t = t.SubStr(prefix.Length);

        array<string> parts = t.Split("_");
        if (parts.Length != 2) return t;
        string datePart = parts[0];

        array<string> timeParts = parts[1].Split("-");
        while (timeParts.Length < 3) timeParts.InsertLast("00");

        return datePart + "_" + timeParts[0] + "-" + timeParts[1] + "-" + timeParts[2];
    }


    string ReadExeBuildFromXmlChunk() {
        string xmlString, exeBuild;

        CSystemFidFile@ fidFile = cast<CSystemFidFile>(GetApp().RootMap.MapInfo.Fid);
        if (fidFile is null) {
            log("fidFile null.", LogLevel::Warn, 46, "ReadExeBuildFromXmlChunk");
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
            log("Error reading GBX.", LogLevel::Error, 82, "ReadExeBuildFromXmlChunk");
        }

        return exeBuild;
    }

}
