# Autor: @davilima300
# Script para otimizacao do Windows com foco em jogos

# Bypass de restricoes para execucao automatica do script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 0. Verificacao de versao do Windows
if (-not ([System.Environment]::OSVersion.Version -ge [Version]"10.0")) {
    Write-Host "[ERRO] Este script requer Windows 10 ou superior."
    exit
}

# 1. Backup de configuracoes
try {
    reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" "C:\Backup\DeliveryOptimization.reg"
    Write-Host "[SUCESSO] Backup de DeliveryOptimization realizado."
} catch {
    Write-Host "[ERRO] Falha ao realizar backup de DeliveryOptimization: $_"
}

# 2. Desativar "Permitir downloads de outros dispositivos"
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "DODownloadMode" -Value 0
    Write-Host "[SUCESSO] Downloads de outros dispositivos desativados com sucesso."
} catch {
    Write-Host "[ERRO] Falha ao desativar downloads de outros dispositivos: $_"
}

# 3. Desativar dispositivo: AMD Crash Defender
try {
    $devenv = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*AMD Crash Defender*" }
    if ($devenv) {
        Disable-PnpDevice -InstanceId $devenv.DeviceID -Confirm:$false
        Write-Host "[SUCESSO] AMD Crash Defender desativado."
    } else {
        Write-Host "[INFORMACAO] Dispositivo 'AMD Crash Defender' nao encontrado no sistema."
    }
} catch {
    Write-Host "[ERRO] Falha ao desativar o dispositivo 'AMD Crash Defender': $_"
}

# 4. Desativar dispositivo: Timer de Eventos de Alta Precisao
try {
    $timerDevice = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*High Precision Event Timer*" }
    if ($timerDevice) {
        Disable-PnpDevice -InstanceId $timerDevice.DeviceID -Confirm:$false
        Write-Host "[SUCESSO] Timer de Eventos de Alta Precisao desativado."
    } else {
        Write-Host "[INFORMACAO] Dispositivo 'Timer de Eventos de Alta Precisao' nao encontrado."
    }
} catch {
    Write-Host "[ERRO] Falha ao desativar 'Timer de Eventos de Alta Precisao': $_"
}

# 5. Configurar politica de grupo para nao incluir drivers nas atualizacoes
try {
    $policyPath = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }
    New-ItemProperty -Path $policyPath -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Host "[SUCESSO] Politica de grupo configurada para excluir drivers nas atualizacoes de qualidade."
} catch {
    Write-Host "[ERRO] Falha ao configurar a politica de grupo: $_"
}

# 6. Alterar plano de energia para "Alto Desempenho"
try {
    $powerPlan = powercfg -L | Select-String -Pattern "High performance"
    if ($powerPlan) {
        $powerPlanGUID = ($powerPlan -split " ")[3]
        powercfg -S $powerPlanGUID
        Write-Host "[SUCESSO] Plano de energia 'Alto Desempenho' ativado."
    } else {
        Write-Host "[INFORMACAO] Plano de energia 'Alto Desempenho' nao encontrado."
    }
} catch {
    Write-Host "[ERRO] Falha ao alterar plano de energia: $_"
}

# 7. Desmarcar "Permitir acesso remoto" nas configuracoes de assistencia remota
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0
    Write-Host "[SUCESSO] Acesso remoto desabilitado."
} catch {
    Write-Host "[ERRO] Falha ao desabilitar acesso remoto: $_"
}

# 8. Configuracoes de otimizacao para jogos no Windows 11
# - Habilitar Modo de Jogo
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
    Write-Host "[SUCESSO] Modo de Jogo ativado com sucesso."
} catch {
    Write-Host "[ERRO] Falha ao ativar o Modo de Jogo: $_"
}

# - Desativar notificacoes durante o jogo
try {
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" -Name "FocusAssistState" -Value 2 -PropertyType DWord -Force | Out-Null
    Write-Host "[SUCESSO] Notificacoes desativadas durante o jogo."
} catch {
    Write-Host "[ERRO] Falha ao desativar notificacoes: $_"
}

# - Configuracoes do adaptador de rede para jogos
try {
    $adapterName = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name
    if ($adapterName) {
        Write-Host "[INFORMACAO] Configurando adaptador de rede: $adapterName"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Flow Control" -DisplayValue "Rx & Tx Enabled"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Interrupt Moderation" -DisplayValue "Enabled"
        New-NetIPAddress -InterfaceAlias $adapterName -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1 -ErrorAction Stop
        Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses 1.1.1.1,8.8.8.8 -ErrorAction Stop
        Write-Host "[SUCESSO] Configuracao do adaptador de rede otimizada."
    } else {
        Write-Host "[INFORMACAO] Nenhum adaptador de rede ativo encontrado para configuracao."
    }
} catch {
    Write-Host "[ERRO] Falha ao configurar adaptador de rede: $_"
}

# 9. Desativar Limitacao de Largura de Banda
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched" -Name "NonBestEffortLimit" -Value 0 -PropertyType DWord -Force
    Write-Host "[SUCESSO] Limitacao de largura de banda desativada."
} catch {
    Write-Host "[ERRO] Falha ao desativar limitacao de largura de banda: $_"
}

# 10. Priorizar Jogos no Gerenciador de Pacotes
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" -Name "GamingTrafficPriority" -Value 1 -PropertyType DWord -Force
    Write-Host "[SUCESSO] Jogos priorizados no gerenciador de pacotes."
} catch {
    Write-Host "[ERRO] Falha ao priorizar jogos: $_"
}

# 11. Desativar Atualizacoes Automaticas
try {
    Stop-Service -Name wuauserv -Force
    Set-Service -Name wuauserv -StartupType Disabled
    Write-Host "[SUCESSO] Atualizacoes automaticas desativadas."
} catch {
    Write-Host "[ERRO] Falha ao desativar atualizacoes automaticas: $_"
}

# 12. Limpar Arquivos Temporarios e Cache
try {
    Get-ChildItem -Path "C:\Windows\Temp", "C:\Users\$env:User Name\AppData\Local\Temp" -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host "[SUCESSO] Arquivos temporarios e cache limpos."
} catch {
    Write-Host "[ERRO] Falha ao limpar arquivos temporarios e cache: $_"
}

# 13. Desativar Windows Search
try {
    Stop-Service -Name "WSearch" -Force
    Set-Service -Name "WSearch" -StartupType Disabled
    Write-Host "[SUCESSO] Windows Search desativado."
} catch {
    Write-Host "[ERRO] Falha ao desativar Windows Search: $_"
}

# 14. Relatorio Final
Write-Host "`nRelatorio de Otimizacao:"
Write-Host "1. Downloads de outros dispositivos: Desativado"
Write-Host "2. AMD Crash Defender: Desativado"
Write-Host "3. Timer de Eventos de Alta Precis
