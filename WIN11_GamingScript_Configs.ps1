# Autor: @davilima300
# Bypass de restrições para execução automática do script
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 1. Desativar "Permitir downloads de outros dispositivos"
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "DODownloadMode" -Value 0
    Write-Host "[SUCESSO] Downloads de outros dispositivos desativados com sucesso."
} catch {
    Write-Host "[ERRO] Falha ao desativar downloads de outros dispositivos: $_"
}

# 2. Desativar dispositivo: AMD Crash Defender
try {
    $devenv = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*AMD Crash Defender*" }
    if ($devenv) {
        Disable-PnpDevice -InstanceId $devenv.DeviceID -Confirm:$false
        Write-Host "[SUCESSO] AMD Crash Defender desativado."
    } else {
        Write-Host "[INFORMAÇÃO] Dispositivo 'AMD Crash Defender' não encontrado no sistema."
    }
} catch {
    Write-Host "[ERRO] Falha ao desativar o dispositivo 'AMD Crash Defender': $_"
}

# 3. Desativar dispositivo: Timer de Eventos de Alta Precisão
try {
    $timerDevice = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Name -like "*High Precision Event Timer*" }
    if ($timerDevice) {
        Disable-PnpDevice -InstanceId $timerDevice.DeviceID -Confirm:$false
        Write-Host "[SUCESSO] Timer de Eventos de Alta Precisão desativado."
    } else {
        Write-Host "[INFORMAÇÃO] Dispositivo 'Timer de Eventos de Alta Precisão' não encontrado."
    }
} catch {
    Write-Host "[ERRO] Falha ao desativar 'Timer de Eventos de Alta Precisão': $_"
}

# 4. Configurar política de grupo para não incluir drivers nas atualizações
try {
    $policyPath = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
    if (-not (Test-Path $policyPath)) {
        New-Item -Path $policyPath -Force | Out-Null
    }
    New-ItemProperty -Path $policyPath -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Host "[SUCESSO] Política de grupo configurada para excluir drivers nas atualizações de qualidade."
} catch {
    Write-Host "[ERRO] Falha ao configurar a política de grupo: $_"
}

# 5. Alterar plano de energia para "Alto Desempenho"
try {
    $powerPlan = powercfg -L | Select-String -Pattern "High performance"
    if ($powerPlan) {
        $powerPlanGUID = ($powerPlan -split " ")[3]
        powercfg -S $powerPlanGUID
        Write-Host "[SUCESSO] Plano de energia 'Alto Desempenho' ativado."
    } else {
        Write-Host "[INFORMAÇÃO] Plano de energia 'Alto Desempenho' não encontrado."
    }
} catch {
    Write-Host "[ERRO] Falha ao alterar plano de energia: $_"
}

# 6. Desmarcar "Permitir acesso remoto" nas configurações de assistência remota
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0
    Write-Host "[SUCESSO] Acesso remoto desabilitado."
} catch {
    Write-Host "[ERRO] Falha ao desabilitar acesso remoto: $_"
}

# 7. Configurações de otimização para jogos no Windows 11
# - Habilitar Modo de Jogo
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
    Write-Host "[SUCESSO] Modo de Jogo ativado com sucesso."
} catch {
    Write-Host "[ERRO] Falha ao ativar o Modo de Jogo: $_"
}

# - Desativar notificações durante o jogo
try {
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" -Name "FocusAssistState" -Value 2 -PropertyType DWord -Force | Out-Null
    Write-Host "[SUCESSO] Notificações desativadas durante o jogo."
} catch {
    Write-Host "[ERRO] Falha ao desativar notificações: $_"
}

# - Desativar Barra de Jogos do Xbox
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0
    Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 2
    Write-Host "[SUCESSO] Barra de Jogos do Xbox desativada."
} catch {
    Write-Host "[ERRO] Falha ao desativar Barra de Jogos do Xbox: $_"
}

# 8. Configuração do adaptador de rede para otimização de jogos
try {
    $adapterName = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name
    if ($adapterName) {
        Write-Host "[INFORMAÇÃO] Configurando adaptador de rede: $adapterName"

        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Advanced EEE" -DisplayValue "Disabled"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Auto Disable Gigabit" -DisplayValue "Disabled"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Flow Control" -DisplayValue "Rx & Tx Enabled"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Interrupt Moderation" -DisplayValue "Enabled"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Jumbo Packet" -DisplayValue "9014"
        Set-NetAdapterAdvancedProperty -Name $adapterName -DisplayName "Speed & Duplex" -DisplayValue "1.0 Gbps Full Duplex"

        New-NetIPAddress -InterfaceAlias $adapterName -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1 -ErrorAction Stop
        Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses 1.1.1.1,8.8.8.8 -ErrorAction Stop

        Write-Host "[SUCESSO] Configuração do adaptador de rede otimizada para jogos concluída."
    } else {
        Write-Host "[INFORMAÇÃO] Nenhum adaptador de rede ativo encontrado para configuração."
    }
} catch {
    Write-Host "[ERRO] Falha ao configurar adaptador de rede: $_"
}

Write-Host "`nTodas as configurações foram processadas com sucesso. Pressione qualquer tecla para sair..."
Read-Host
