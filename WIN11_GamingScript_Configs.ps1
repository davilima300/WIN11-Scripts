<# 
Autor: @davilima300
Descrição: Script de otimização de Windows 10/11 focado em jogos.
Compatível com PowerShell 5+
#>

# =====================================
# FUNÇÕES AUXILIARES
# =====================================
function Write-Log {
    param(
        [string]$Mensagem,
        [string]$Tipo = "INFO"
    )
    switch ($Tipo.ToUpper()) {
        "SUCESSO" { Write-Host "[SUCESSO] $Mensagem" -ForegroundColor Green }
        "ERRO"    { Write-Host "[ERRO] $Mensagem" -ForegroundColor Red }
        "INFO"    { Write-Host "[INFO] $Mensagem" -ForegroundColor Cyan }
        default   { Write-Host "[LOG] $Mensagem" }
    }
}

# =====================================
# CONFIGURAÇÕES INICIAIS
# =====================================
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Write-Log "Iniciando otimização do Windows..." "INFO"

if (-not ([System.Environment]::OSVersion.Version -ge [Version]"10.0")) {
    Write-Log "Este script requer Windows 10 ou superior." "ERRO"
    exit
}

# Criar pasta de backup, se não existir
$backupPath = "C:\Backup"
if (-not (Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
    Write-Log "Pasta de backup criada em $backupPath" "INFO"
}

# =====================================
# 1. BACKUP DE CONFIGURAÇÕES
# =====================================
try {
    reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" "$backupPath\DeliveryOptimization.reg" /y | Out-Null
    Write-Log "Backup de DeliveryOptimization realizado."
} catch {
    Write-Log "Falha ao realizar backup: $_" "ERRO"
}

# =====================================
# 2. DESATIVAR DOWNLOADS ENTRE DISPOSITIVOS
# =====================================
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" -Name "DODownloadMode" -Value 0
    Write-Log "Downloads de outros dispositivos desativados." "SUCESSO"
} catch {
    Write-Log "Falha ao desativar downloads entre dispositivos: $_" "ERRO"
}

# =====================================
# 3. DESATIVAR AMD CRASH DEFENDER
# =====================================
try {
    $amdDevice = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*AMD Crash Defender*" }
    if ($amdDevice) {
        Disable-PnpDevice -InstanceId $amdDevice.InstanceId -Confirm:$false
        Write-Log "AMD Crash Defender desativado." "SUCESSO"
    } else {
        Write-Log "Dispositivo AMD Crash Defender não encontrado." "INFO"
    }
} catch {
    Write-Log "Erro ao desativar AMD Crash Defender: $_" "ERRO"
}

# =====================================
# 4. DESATIVAR TIMER DE EVENTOS DE ALTA PRECISÃO
# =====================================
try {
    $hpet = Get-PnpDevice | Where-Object { $_.FriendlyName -like "*High Precision Event Timer*" }
    if ($hpet) {
        Disable-PnpDevice -InstanceId $hpet.InstanceId -Confirm:$false
        Write-Log "Timer de Eventos de Alta Precisão desativado." "SUCESSO"
    } else {
        Write-Log "HPET não encontrado." "INFO"
    }
} catch {
    Write-Log "Falha ao desativar HPET: $_" "ERRO"
}

# =====================================
# 5. EXCLUIR DRIVERS DAS ATUALIZAÇÕES DE QUALIDADE
# =====================================
try {
    $policyPath = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate"
    if (-not (Test-Path $policyPath)) { New-Item -Path $policyPath -Force | Out-Null }
    Set-ItemProperty -Path $policyPath -Name "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord
    Write-Log "Drivers excluídos das atualizações de qualidade." "SUCESSO"
} catch {
    Write-Log "Falha ao ajustar política de drivers: $_" "ERRO"
}

# =====================================
# 6. PLANO DE ENERGIA ALTO DESEMPENHO
# =====================================
try {
    $plan = powercfg -l | Select-String "High performance"
    if ($plan) {
        $guid = ($plan -split " ")[3]
        powercfg -S $guid
        Write-Log "Plano de energia 'Alto Desempenho' ativado." "SUCESSO"
    } else {
        Write-Log "Plano 'Alto Desempenho' não encontrado." "INFO"
    }
} catch {
    Write-Log "Erro ao configurar plano de energia: $_" "ERRO"
}

# =====================================
# 7. DESATIVAR ASSISTÊNCIA REMOTA
# =====================================
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Value 0
    Write-Log "Assistência Remota desabilitada." "SUCESSO"
} catch {
    Write-Log "Falha ao desabilitar Assistência Remota: $_" "ERRO"
}

# =====================================
# 8. ATIVAR MODO DE JOGO
# =====================================
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1
    Write-Log "Modo de Jogo ativado." "SUCESSO"
} catch {
    Write-Log "Falha ao ativar Modo de Jogo: $_" "ERRO"
}

# =====================================
# 9. DESATIVAR NOTIFICAÇÕES DURANTE JOGOS
# =====================================
try {
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\FocusAssist" -Name "FocusAssistState" -Value 2 -PropertyType DWord -Force | Out-Null
    Write-Log "Notificações desativadas durante o jogo." "SUCESSO"
} catch {
    Write-Log "Erro ao configurar notificações: $_" "ERRO"
}

# =====================================
# 10. OTIMIZAR ADAPTADOR DE REDE
# =====================================
try {
    $adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
    if ($adapter) {
        Write-Log "Otimizando adaptador de rede: $($adapter.Name)" "INFO"
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Flow Control" -DisplayValue "Rx & Tx Enabled"
        Set-NetAdapterAdvancedProperty -Name $adapter.Name -DisplayName "Interrupt Moderation" -DisplayValue "Enabled"
        Write-Log "Configurações de rede aplicadas." "SUCESSO"
    } else {
        Write-Log "Nenhum adaptador ativo encontrado." "INFO"
    }
} catch {
    Write-Log "Falha ao otimizar adaptador de rede: $_" "ERRO"
}

# =====================================
# 11. LIMITAÇÃO DE LARGURA DE BANDA
# =====================================
try {
    $path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Psched"
    if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
    Set-ItemProperty -Path $path -Name "NonBestEffortLimit" -Value 0 -Type DWord
    Write-Log "Limitação de banda desativada." "SUCESSO"
} catch {
    Write-Log "Falha ao remover limitação de banda: $_" "ERRO"
}

# =====================================
# 12. LIMPAR ARQUIVOS TEMPORÁRIOS
# =====================================
try {
    Get-ChildItem -Path "$env:TEMP", "C:\Windows\Temp" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Write-Log "Arquivos temporários e cache limpos." "SUCESSO"
} catch {
    Write-Log "Erro ao limpar arquivos temporários: $_" "ERRO"
}

# =====================================
# 13. RELATÓRIO FINAL
# =====================================
Write-Host "`n======================================="
Write-Host "       RELATÓRIO DE OTIMIZAÇÃO"
Write-Host "=======================================" -ForegroundColor Yellow
Write-Log "Delivery Optimization: Desativado"
Write-Log "AMD Crash Defender: Desativado"
Write-Log "HPET: Desativado"
Write-Log "Drivers em updates: Excluídos"
Write-Log "Plano de energia: Alto desempenho"
Write-Log "Assistência remota: Desativada"
Write-Log "Modo de jogo: Ativado"
Write-Log "Notificações: Desativadas"
Write-Log "Adaptador de rede: Otimizado"
Write-Log "Limitação de banda: Desativada"
Write-Log "Arquivos temporários: Limpos"
Write-Host "`n[FINALIZADO] Otimização concluída!" -ForegroundColor Green
