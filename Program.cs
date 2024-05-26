using System;
using System.Diagnostics;
using System.Windows;

namespace AX_SYS
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.Clear();
            AX_SYS();
            void AX_SYS ()
            {
                Console.WriteLine("AX-SYS Builder V5");
                Console.WriteLine("");
                Console.WriteLine("Press 'B' to Build ISO.");
                Console.WriteLine("Press 'O' to Open 'startnet.cmd'");
                ConsoleKeyInfo Key = Console.ReadKey();
                char PressedKey = Key.KeyChar;
                string PressedKeyString = PressedKey.ToString().ToLower();
                switch (PressedKeyString)
                {
                    case "b":
                        StartBuildProcess();
                        break;
                    case "o":
                        OpenEditors();
                        break;
                }
                Repeat();
            }
            void Repeat ()
            {
                Console.Clear();
                AX_SYS ();
            }
        }
        static void StartBuildProcess()
        {
            Process Builder = new Process();
            Builder.StartInfo.FileName = "cmd.exe";
            Builder.StartInfo.Arguments = "/c pause && exit";
            Builder.Start();
        }
        static void OpenEditors()
        {
            MessageBox.Show("Work In Progress");
        }
    }
}
