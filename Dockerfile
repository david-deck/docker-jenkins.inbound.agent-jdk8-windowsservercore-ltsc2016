# escape=`

ARG VERSION=4.3-4
FROM jenkins/agent:${VERSION}-windowsservercore-1809

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
ENTRYPOINT ["powershell.exe", "-f", "C:/ProgramData/Jenkins/jenkins-agent.ps1"]
