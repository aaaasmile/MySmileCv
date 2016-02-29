﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Ionic.Zip;
using Microsoft.Win32;
using System.Security.AccessControl;

namespace RubyAppStarterLib
{
    public class AppStarter
    {
        private static log4net.ILog _log = log4net.LogManager.GetLogger(typeof(AppStarter));

        public event EventHandler<EventArgs> ApplicationStarting = delegate { };
        private string _keyRootName = @"Software\invido_it\";
        private readonly string _projectName;
        private ProcessStarter _processStarter;

        public AppStarter(string projectName)
        {
            _projectName = projectName;
            _keyRootName += projectName;
        }

        public void Run()
        {
            RegistryRootWrapper currentUserSettings = new RegistryRootWrapper(Registry.CurrentUser.CreateSubKey(_keyRootName), isReadOnly: false);
            RegistryRootWrapper applicationSettings = new RegistryRootWrapper(
                Registry.LocalMachine.OpenSubKey(_keyRootName), isReadOnly: true);

            string installDir = applicationSettings.GetValue<string>("InstallDir", null);
            string rubyZip = applicationSettings.GetValue<string>("RubyPackage", null);
            if (!currentUserSettings.GetValue<bool>("RubyPackgeUnzipped", false))
            {
                ExtractRubyPackage(installDir, rubyZip);
                currentUserSettings.SetValue("RubyPackgeUnzipped", true);
            }
            AppPackageSettings appPackageSettings = new AppPackageSettings(applicationSettings);
            if (!currentUserSettings.GetValue<bool>("AppPackgeUnzipped", false))
            {
                ExtractAppPackage(installDir, appPackageSettings.AppZipName, appPackageSettings.AppVersion);
                currentUserSettings.SetValue("AppPackgeUnzipped", true);
            }

            string rubyExePath = GetRubyExePath(rubyZip);
            if (!File.Exists(rubyExePath)) throw (
                   new ArgumentException(string.Format("Ruby.exe  {0} not found", rubyExePath)));
            _log.InfoFormat("Ruby cmd {0}", rubyExePath);

            string startScriptFullPath = GetStartScript(appPackageSettings.AppVersion, appPackageSettings.AppStartScript);
            if (!File.Exists(startScriptFullPath)) throw (
                   new ArgumentException(string.Format("Start script  {0} not found", startScriptFullPath)));

            _processStarter = new ProcessStarter();
            ApplicationStarting(this, null);
            _processStarter.ExecuteCmd(rubyExePath, startScriptFullPath);
        }

        public void Stop()
        {
            _processStarter.StopProcess();
        }

        private void ExtractAppPackage(string installDir, string appZip, string appVersion)
        {
            string appZipPackagePath = Path.Combine(Path.Combine(installDir, "App"), appZip);
            if (!File.Exists(appZipPackagePath)) throw (
                    new ArgumentException(string.Format("App package {0} not found", appZip)));

            string appDestinationDir = GetAppDestinationDir(appVersion);
            ExtractFiles(appZipPackagePath, appDestinationDir);
        }

        private void ExtractRubyPackage(string installDir, string rubyZip)
        {
            string rubyZipPackagePath = Path.Combine(Path.Combine(installDir, "Ruby"), rubyZip);
            if (!File.Exists(rubyZipPackagePath)) throw (
                    new ArgumentException(string.Format("Ruby package {0} not found", rubyZip)));

            string rubyDestinationDir = GetRubyDestinationDir(rubyZip);
            ExtractFiles(rubyZipPackagePath, rubyDestinationDir);
        }

        private string GetRootUnpackedData()
        {
            string dataDir = @"invido_it\" + _projectName;
            return Path.Combine(
                     Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                     dataDir);
        }

        private string GetStartScript(string appVersion, string appStartScript)
        {
            return Path.Combine(
                GetAppDestinationDir(appVersion),
                string.Format(@"app/{0}", appStartScript));
        }

        private string GetAppDestinationDir(string appVersion)
        {
            return Path.Combine(GetRootUnpackedData(), appVersion);
        }

        private string GetRubyExePath(string rubyZip)
        {
            string root = GetRubyDestinationDir(rubyZip);
            return Path.Combine(root, "ruby/bin/ruby.exe");
        }

        private string GetRubyDestinationDir(string rubyZip)
        {
            return Path.Combine(GetRootUnpackedData(),
                Path.GetFileNameWithoutExtension(rubyZip));
        }

        private void ExtractFiles(string archPath, string destinationDir)
        {
            _log.InfoFormat("Extracting {0} files into {1}", archPath, destinationDir);

            using (ZipFile zipFile = new ZipFile(archPath))
                foreach (ZipEntry entry in zipFile.Entries)
                {

                    string destinationPath = Path.Combine(destinationDir, entry.FileName);
                    entry.Extract(destinationDir, ExtractExistingFileAction.OverwriteSilently);
                    _log.DebugFormat("{0} extracted", entry.FileName);
                }
        }
    }
}
