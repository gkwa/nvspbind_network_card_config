REM -*- bat -*-
@Echo on

rem make port 1 first in binding order
nvspbind.exe /+ "Local Area Connection" ms_tcpip

for %%G in ("Local Area Connection" "Local Area Connection 2") do (

    nvspbind.exe /e %%G ms_netbios
    nvspbind.exe /d %%G ms_pacer
    nvspbind.exe /d %%G ms_server
    nvspbind.exe /d %%G ms_tcpip6
    nvspbind.exe /e %%G ms_tcpip4

)
