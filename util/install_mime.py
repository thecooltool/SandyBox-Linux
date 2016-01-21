'''
Installs a Bash mime type

Copyright 2014 Alexander Roessler @ TheCoolTool
'''

import shutil
import os
import sys
import platform


appDir = os.path.expanduser('~/.local/share/applications')
desktopFile = 'bash.desktop'
mimeFile = os.path.join(appDir, 'mimeapps.list')


def info(message):
    """ Displays a info message """
    sys.stdout.write(message)
    sys.stdout.flush()


def applicationExists(executable):
    for p in os.environ["PATH"].split(os.pathsep):
        if os.path.exists(os.path.join(p, executable)):
            return True
    return False


def init():
    global desktopFile
    desktopFile = 'bash.desktop'
    system = platform.dist()[0]
    if (system == 'Ubuntu') and applicationExists('gnome-terminal'):
        info('Using Ubuntu type\n')
        desktopFile = 'bash-ubuntu.desktop'

    
def copyDesktopFile():
    targetFile = os.path.join(appDir, desktopFile)
    
    if not os.path.exists(appDir):
        os.makedirs(appDir)
    
    if os.path.exists(targetFile):
        os.remove(targetFile)
    
    info('Copying desktop file ... ')
    shutil.copy(desktopFile, targetFile)
    info('done\n')
    
    
def ensureMimeFile():
    if not os.path.exists(mimeFile):
        with open(mimeFile, 'w') as f:
            f.close()
    
    
def insertEntry():
    mimeType = 'application/x-shellscript'
    section = '[Added Associations]'
    entryLine = -1
    sectionLine = -1
    
    info('Reading mimeinfo.list ... ')
    with open(mimeFile, 'r') as f:
        data = f.read()
        f.close()
    info('done\n')
        
    info('Manipulating data ... ')
    dataList = data.split('\n')
    
    for i, line in enumerate(dataList):
        if mimeType in line:
            entryLine = i
        if section in line:
            sectionLine = i
            
    if entryLine != -1:
        line = dataList[entryLine][len(mimeType)+1:]
        line = mimeType + '=' + desktopFile + ';' + line
        dataList[entryLine] = line
    else:
        line = mimeType + '=' + desktopFile + ';'
        if sectionLine == -1:
            dataList.append(section)
            sectionLine = len(dataList)-1
        dataList.insert(sectionLine+1, line)
    info('done\n')
    
    info('Writing mimeinfo.list ...')
    with open(mimeFile, 'w') as f:
        f.write('\n'.join(dataList))
        f.close()
    info('done\n')

init()
copyDesktopFile()
ensureMimeFile()
insertEntry()
