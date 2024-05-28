using System.Diagnostics;
using System.IO;
using System.Xml;

namespace AX_SYS
{
    internal class Program
    {
        static void Main()
        {
            Process Builder = new Process();
            Builder.StartInfo.FileName = "cmd.exe";
            Builder.StartInfo.Arguments = "/c build_iso.bat";
            Builder.Start();
        }
    }
}
