using System.Diagnostics;
using System.IO;
using System.Xml;

namespace AX_SYS
{
    internal class Program
    {
        static void Main()
        {
            string args = @"/c
            dism /cleanup-wim
            pause";

            Process Builder = new Process();
            Builder.StartInfo.FileName = "cmd.exe";
            Builder.StartInfo.Arguments = args;
            Builder.Start();
        }
    }
}
