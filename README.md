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
   - Pressione `Win + X` e selecione **Terminal (Admin)** ou **Windows PowerShell (Admin)**.  
   - Confirme a permissão, se solicitado.  

2️⃣ **Definir a Política de Execução (se necessário):**  
   - Antes de executar o script, você pode definir a política de execução para permitir a execução de scripts. Execute o seguinte comando:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  -Force

   Observação: Isso permite a execução de scripts que você criou ou baixou de fontes confiáveis.

3️⃣ Navegar até o Diretório do Script:

   Use o comando cd para navegar até o diretório onde o script está localizado. Por exemplo:

   cd "C:\Caminho\Para\Seu\Script"

4️⃣ Executar o Script:

   Execute o script digitando .\NomeDoSeuScript.ps1 e pressione Enter.
   Exemplo:

   .\configuracao_windows11.ps1

💡 Dicas Adicionais:
   Verifique o Caminho do Script: Certifique-se de que o caminho do script está correto ao usar o comando cd.
   Usar o PowerShell ISE: Se preferir, você pode abrir o PowerShell ISE (Integrated Scripting Environment) como administrador e carregar o script lá para facilitar    a execução e depuração.
   Criar um Atalho: Para facilitar a execução futura, você pode criar um atalho para o script e configurá-lo para ser executado como administrador.

   # Abrir PowerShell como Administrador
   # Definir a política de execução
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser  -Force
   
   # Navegar até o diretório do script
   cd "C:\Caminho\Para\Seu\Script"
   
   # Executar o script
   .\configuracao_windows11.ps1
