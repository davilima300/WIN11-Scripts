# 🎮 WIN11-Scripts  
Scripts para automação da instalação e configuração do Windows 11 - **GAMING!**  

# 🚀 **Script de Automação para Instalação e Configuração do Windows11**  

**👤 Autor:** [@Davilima300](#)  

Este projeto contém dois scripts principais:  
- ⚡ **Script de Automação de Instalação do Windows 11:** Automatiza o processo de instalação do sistema operacional.  
- 🎯 **Script de Automação de Configuração do Windows 11:** Realiza otimizações específicas para **performance e jogos**.  

---  

## 🖥️ **1. Script de Instalação do Windows 11**  

### 🔧 **Passos para Configuração**  

1️⃣ **Preparar o Pendrive Bootável/ISO:**  
   Certifique-se de que você já criou um **pendrive bootável** ou **ISO do Windows 11** com ferramentas como o **Rufus** ou **Media Creation Tool**.  

2️⃣ **Adicionar o Arquivo `autounattend.xml`:**  
   Copie o arquivo **`autounattend.xml`** (fornecido neste projeto) para a **raiz do seu pendrive/ISO**, onde estão as pastas como `boot`, `efi`, `sources`, etc.  

3️⃣ **Iniciar a Instalação:**  
   - Conecte o **pendrive ao computador**.  
   - Configure a **BIOS/UEFI** para iniciar pelo **dispositivo USB**.  
   - A instalação será automatizada com base nas configurações do arquivo `autounattend.xml`.  

---

## 🚀 **2. Script de Configuração do Windows 11**  

### 📌 **Como Executar**  

1️⃣ **Abrir o PowerShell como Administrador:**  
   - Pressione `Win + X` e selecione **Terminal (Admin)** ou **PowerShell (Admin)**.  
   - Confirme a permissão, se solicitado.  

2️⃣ **Executar o Script:**  
   - **Arraste o arquivo do script (`.ps1`) para a janela do PowerShell.**  
   - Pressione **Enter** para iniciar a execução.  

💡 **Observação:** Caso a execução de scripts esteja bloqueada, rode antes:  
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
