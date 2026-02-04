pragma Singleton

import qs.module.common
import qs.module.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  property var launchCounts: ({})
  property real maxCount: 1
  property bool ready: false
  property bool writePending: false

  function recordLaunch(appId: string) {
    if (!appId || appId.length === 0) return

    const currentCount = root.launchCounts[appId] || 0
    const newCount = currentCount+1

    let updated = Object.assign({}, root.launchCounts)
    updated[appId] = newCount
    root.launchCounts = updated

    if (newCount > root.maxCount) {
      root.maxCount = newCount
    }
  }

  function getScore(appId: string): real {
    if (!appId || appId.length === 0) return 0
    const count = root.launchCounts[appId] || 0
    if (count === 0 || root.maxCount === 0) return 0
    return count/root.maxCount
  }

  function getCount(appId: string): int {
    if (!appId || appId.length === 0) return 0
    return root.launchCounts[appId] || 0
  }

  Timer {
    id: fileReloadTimer
    interval: 100
    repeat: false
    onTriggered: {
      if (!root.writePending) {
        usageFileView.reload()
      }
    }
  }

  Timer {
    id: fileWriteTimer
    interval: 500
    repeat: false
    onTriggered: {
      usageFileView.writeAdapter()
      root.writePending = false
    }
  }

  onLaunchCountsChanged: {
    if (root.ready) {
      root.writePending = true
      fileWriteTimer.restart()
    }
  }

  FileView {
    id: usageFileView
    path: Directories.appUsagePath

    watchChanges: true
    onFileChanged: fileReloadTimer.restart()
    onLoaded: {
      let max = 1
      for (const appId in usageAdapter.counts) {
        if (usageAdapter.counts[appId] > max) {
          max = usageAdapter.counts[appId]
        }
      }
      root.maxCount = max
      root.launchCounts = usageAdapter.launchCounts
      root.ready = true
    }
    onLoadFailed: error => {
      if (error == FileViewError.FileNotFound) {
        root.ready = true
        fileWriteTimer.restart()
      } else {
        console.warn("AppUsage: Failed to load usage data:", error)
        root.ready = true
      }
    }

    adapter: JsonAdapter {
      id: usageAdapter
      property var counts: root.launchCounts
    }
  }
}
