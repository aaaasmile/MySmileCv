using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Threading;

namespace RubyAppStarterLib
{
    class ProcessStarter
    {
        private static log4net.ILog _log = log4net.LogManager.GetLogger(typeof(ProcessStarter));
        private Process _processRun;

        internal void ExecuteCmd(string rubyExe, string startScript)
        {
            if (_processRun != null)
                throw new ArgumentException("Process already started");

            string cmdoptionComplete = string.Format("'{0}'", startScript);

            _log.InfoFormat("Using comand: {0} {1}", rubyExe, cmdoptionComplete);

            _processRun = new Process();
            _processRun.StartInfo.UseShellExecute = false;
            _processRun.StartInfo.RedirectStandardOutput = true;
            _processRun.StartInfo.RedirectStandardError = true;
            _processRun.StartInfo.CreateNoWindow = true;
            _processRun.StartInfo.FileName = rubyExe;
            _processRun.StartInfo.Arguments = cmdoptionComplete;
            _processRun.OutputDataReceived += new DataReceivedEventHandler(_processRun_OutputDataReceived);
            _processRun.ErrorDataReceived += new DataReceivedEventHandler(_processRun_ErrorDataReceived);
            _processRun.Start();
            _log.InfoFormat("Ruby process is started");
            _processRun.BeginOutputReadLine();

            do
            {

            } while (!_processRun.WaitForExit(1000));


            _processRun.OutputDataReceived -= _processRun_OutputDataReceived;
            _processRun.ErrorDataReceived -= _processRun_ErrorDataReceived;

            _log.DebugFormat("Application exit code {0}", _processRun.ExitCode);

        }

        internal void StopProcess()
        {
            _log.DebugFormat("Kill the process");
            _processRun.Kill();
        }

        void _processRun_ErrorDataReceived(object sender, DataReceivedEventArgs e)
        {
            if (!String.IsNullOrEmpty(e.Data))
            {
                _log.ErrorFormat("STDERR: {0}", e.Data);
            }
        }

        void _processRun_OutputDataReceived(object sender, DataReceivedEventArgs e)
        {
            if (!String.IsNullOrEmpty(e.Data))
            {
                _log.DebugFormat("STDOUT: {0}", e.Data);
            }
        }
    }
}
