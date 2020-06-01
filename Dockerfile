# escape=`

FROM --platform=windows/amd64 edgehog/jenkins.agent:jdk8-windowsservercore-ltsc2016

LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols on Windows" Vendor="Jenkins Project" Version="$VERSION"

ARG user=jenkins

RUN $output = net users ; `
    if(-not ($output -match $env:user)) { `
        Write-Host 'user does not exist?' ; `
        net user $env:user /add /expire:never /passwordreq:no ; `
        net localgroup Administrators /add $env:user `
    }

COPY jenkins-agent.ps1 C:/ProgramData/Jenkins

USER ${user}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT C:/ProgramData/Jenkins/jenkins-agent.ps1
