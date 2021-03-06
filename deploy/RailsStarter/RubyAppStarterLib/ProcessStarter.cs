﻿using System;
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

        // NOTE: avoid to redirect stdout in rails applications 
        internal void ExecuteCmd(string rubyExe, string startScript, string workingDir, EventHandler<EventArgs> started, bool redirectStdout = false)
        {
            if (_processRun != null)
                throw new ArgumentException("Process already started");

            string cmdoptionComplete = string.Format("'{0}'", startScript);

            _log.InfoFormat("Using comand: {0} {1}", rubyExe, cmdoptionComplete);

            _processRun = new Process();
            _processRun.StartInfo.UseShellExecute = false;
            _processRun.StartInfo.RedirectStandardOutput = redirectStdout;
            _processRun.StartInfo.RedirectStandardError = redirectStdout;
            _processRun.StartInfo.CreateNoWindow = true;
            _processRun.StartInfo.FileName = rubyExe;
            _processRun.StartInfo.WorkingDirectory = workingDir;
            _processRun.StartInfo.Arguments = cmdoptionComplete;
            _processRun.Start();
            _log.InfoFormat("Ruby process is started, redirect stdout {0}", redirectStdout);
            if (redirectStdout)
            {
                _processRun.OutputDataReceived += new DataReceivedEventHandler(_processRun_OutputDataReceived);
                _processRun.ErrorDataReceived += new DataReceivedEventHandler(_processRun_ErrorDataReceived);

                _processRun.BeginOutputReadLine();
            }


            do
            {
                if (started != null)
                {
                    started(this, null);
                    started = null;
                }

            } while (!_processRun.WaitForExit(1000));


            if (redirectStdout)
            {
                _processRun.OutputDataReceived -= _processRun_OutputDataReceived;
                _processRun.ErrorDataReceived -= _processRun_ErrorDataReceived;
            }

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
