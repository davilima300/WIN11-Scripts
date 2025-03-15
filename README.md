# WIN11-Scripts

Scripts para automação da instalação e configuração do Windows 11 - GAMING! 🎮

**Autor:** @Davilima300

Este projeto contém dois scripts principais:

- **⚡ Script de Instalação do Windows 11:** Automatiza o processo de instalação do sistema operacional.
- **🎯 Script de Configuração do Windows 11:** Realiza otimizações específicas para performance e jogos.

## 1. Script de Instalação do Windows 11

### 🔧 Passos para Configuração

1. **Preparar o Pendrive Bootável/ISO:**  
   Certifique-se de que você já criou um pendrive bootável ou ISO do Windows 11 com ferramentas como **Rufus** ou **Media Creation Tool**.

2. **Adicionar o Arquivo `autounattend.xml`:**  
   Copie o arquivo `autounattend.xml` (fornecido neste projeto) para a raiz do seu pendrive/ISO, onde estão as pastas como **boot**, **efi**, **sources**, etc.

3. **Iniciar a Instalação:**  
   Conecte o pendrive ao computador e configure a BIOS/UEFI para iniciar pelo dispositivo USB. A instalação será automatizada com base nas configurações do arquivo `autounattend.xml`.

---

## 2. Script de Configuração do Windows 11

### 📌 Como Executar

1. **Abrir o PowerShell como Administrador:**  
   - Pressione **Win + X** e selecione **Terminal (Admin)** ou **Windows PowerShell (Admin)**.
   - Confirme a permissão, se solicitado.

2. **Definir a Política de Execução (se necessário):**  
   Execute o seguinte comando para permitir a execução de scripts confiáveis:

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
   ```

---

### 3. Dicas Adicionais

- **Verifique o Caminho do Script:** Certifique-se de que o caminho do script está correto ao usar o comando `cd`.
- **Usar o PowerShell ISE:** Se preferir, abra o **PowerShell ISE** (Integrated Scripting Environment) como administrador e carregue o script para execução e depuração.
- **Criar um Atalho:** Para facilitar futuras execuções, crie um atalho para o script e configure-o para ser executado como administrador.

```powershell
# Abrir PowerShell como Administrador
# Definir a política de execução
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Navegar até o diretório do script
cd "C:\Caminho\Para\Seu\Script"

# Executar o script
.\configuracao_windows11.ps1
