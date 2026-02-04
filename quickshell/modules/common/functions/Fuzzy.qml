pragma Singleton
import Quickshell
import "fuzzysort.js" as FuzzySort

Singleton {
  function go(...args) {
    return FuzzySort.go(...args)
  }

  function prepare(...args) {
    return FuzzySort.prepare(...args)
  }

  function single(...args) {
    return FuzzySort.single(...args)
  }
}

