# Akamai API Wrapper

## Powershell Akamai API Wrapper


### Submodule
Uses a fork of the now deprecated Akamai\AkamaiOPEN-edgegrid-powershell. Tested and still working. Using the fork in case Akamai decide to remove the project from Github.

To clone without having to initialise the submodule use one command to clone all at once
```
git clone git@github.com:scotta01/AkamaiAPIWrapper.git --recurse-submodules
```

### Installation
Copy folder to a PowerShell Module folder. To find the module folders on the local systen check the PSModulePath environment variable.

In PowerShell you can run

```
cat Env:\PSModulePath
```

You can then import the module

```
Import-Module AkamaiAPIWrapper
```