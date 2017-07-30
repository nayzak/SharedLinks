<p align="center">
    <img src="https://github.com/nayzak/shared-links/raw/develop/ReadmeAssets/icon_256x256.png"/>
</p>

<h1 align="center">Shared Links</h1>

 <!-- <p align="center">In the Shared Links, you can see links from people you follow on Twitter, links shared by your LinkedIn connections, and articles from web feeds you subscribe to.</p>  -->
 <p align="center">
    In the Shared Links, you can see links from people you follow on Twitter like you did it in Safari prior 11 release.
    </br>
    <img src="https://github.com/nayzak/shared-links/raw/develop/ReadmeAssets/popover.png"/>
 </p>

***

# Build

**Use pre-compiled dylibs**

1. Please make sure Carthage is installed.

  **homebrew**
  ```
  brew install carthage
  ```
  **or download installer at [Carthage releases page](https://github.com/Carthage/Carthage/releases) and run it.**

2. Run carthage bootstrap in project root directory.
  ```
  carthage bootstrap --platform macOS --configuration Release --cache-builds
  ```

3. Open `.xcodeproj` file.
