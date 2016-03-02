using log4net.Config;
using RubyAppStarterLib;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace RailsStarter
{
    class Program
    {
        private static readonly log4net.ILog _log = log4net.LogManager.GetLogger(typeof(Program));

        static string _consoleTitle = "Starter";
        static AppStarter _appStarter;

        static void Main(string[] args)
        {
            consoleEventHandler = new ConsoleEventDelegate(ConsoleEventHandler);
            SetConsoleCtrlHandler(consoleEventHandler, add: true);

            Console.Title = _consoleTitle;
            string filename = Log4NetConfigFileName();
            XmlConfigurator.ConfigureAndWatch(new FileInfo(filename));
            _log.InfoFormat("*** Starting up version {0} ***",
                 System.Reflection.Assembly.GetExecutingAssembly().GetName().Version);
            Console.WriteLine("Preparing the source...");
            try
            {
                _appStarter = new AppStarter("MySmileCv");
                _appStarter.ApplicationStarted += Starter_ApplicationStarted;
                _appStarter.Run();
                _log.Debug("Program terminated.");
            }
            catch (Exception ex)
            {
                string msg = ex is AppNotSetupException ?
                    "You need to manual setup the application and restart"
                    : "Fatal error, please try reinstall the application or contact the support";
                _log.ErrorFormat("{1}. {0}", ex, msg);
                _appStarter = null;
                
                Console.ReadKey();
            }

        }

        private static bool ConsoleEventHandler(ConsoleEventType eventType)
        {
            if (_appStarter == null) { return true; }

            _log.DebugFormat("Console event {0}", eventType);

            switch (eventType)
            {
                case ConsoleEventType.CTRL_C_EVENT:
                case ConsoleEventType.CTRL_BREAK_EVENT:
                case ConsoleEventType.CTRL_CLOSE_EVENT:
                    _appStarter.Stop();
                    break;
                case ConsoleEventType.CTRL_LOGOFF_EVENT:
                case ConsoleEventType.CTRL_SHUTDOWN_EVENT:
                default:
                    _log.WarnFormat("Ignore console event {0}", eventType);
                    break;
            }
            return true;
        }

        private static void Starter_ApplicationStarted(object sender, EventArgs e)
        {
            //HideOrShowWindow(WindowShowType.Hide);
            //Thread.Sleep(5000);
            //System.Diagnostics.Process.Start("http://localhost:3000");
            _log.Info("Please, open the browser to http://localhost:3000");
        }

        #region Hooks

        private enum WindowShowType
        {
            Hide = 0,
            Show = 5
        }

        private enum ConsoleEventType
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT,
            CTRL_CLOSE_EVENT,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT
        }

        // Show/Hide window
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
        [DllImport("user32.dll")]
        static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        private static void HideOrShowWindow(WindowShowType type)
        {

            IntPtr hWnd = FindWindow(null, _consoleTitle);
            if (hWnd != IntPtr.Zero)
            {
                ShowWindow(hWnd, (int)type); // 0 = SW_HIDE, 5 = SW_SHOW
            }

        }

        // Console events
        static ConsoleEventDelegate consoleEventHandler;   // Keeps it from getting garbage collected
        private delegate bool ConsoleEventDelegate(ConsoleEventType eventType);
        [DllImport("kernel32.dll", SetLastError = true)]
        private static extern bool SetConsoleCtrlHandler(ConsoleEventDelegate callback, bool add);


        #endregion

        private static string Log4NetConfigFileName()
        {
            string dir = Path.GetDirectoryName(Assembly.GetEntryAssembly().Location);
            string name = Assembly.GetEntryAssembly().GetName().Name;

            return Path.Combine(
                dir,
                name + ".Log4net.config");
        }
    }
}
