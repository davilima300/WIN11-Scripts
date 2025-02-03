# WIN11-Scripts
Scripts para automação da instalação e configuração do Windows 11 - GAMING!

# **Script de Automação para Instalação e Configuração do Windows 11**

**Author:** @Davilima300

Este projeto contém dois scripts principais:  
- **Script de Automação de Instalação do Windows 11:** Automatiza o processo de instalação do sistema operacional.  
- **Script de Automação de Configuração do Windows 11:** Realiza otimizações específicas para performance e jogos.  

---

## **1. Script de Instalação do Windows 11**

### **Passos para Configuração**
1. **Preparar o Pendrive Bootável/ISO:**  
   Certifique-se de que você já criou um pendrive bootável ou ISO do Windows 11 com ferramentas como o Rufus ou Media Creation Tool.  

2. **Adicionar o Arquivo `autounattend.xml`:**  
   Copie o arquivo `autounattend.xml` (fornecido neste projeto) para a raiz do seu pendrive/ISO, onde estão as pastas como `boot`, `efi`, `sources`, etc.  

3. **Iniciar a Instalação:**  
   Conecte o pendrive ao computador e configure a BIOS/UEFI para iniciar pelo dispositivo USB. O processo será automatizado com base nas configurações do arquivo `autounattend.xml`.

---

## **2. Script de Configuração do Windows 11**

### **Passos para Executar o Script**

# Executando o Script no PowerShell

## Passo 1: Abrir o PowerShell diretamente na pasta do script  
1. Pressione `Win + E` para abrir o Explorador de Arquivos.  
2. Navegue até a pasta onde o script foi baixado (normalmente `Downloads`).  
3. Segure `Shift` e clique com o botão direito em um espaço vazio dentro da pasta.  
4. Selecione **"Abrir o PowerShell aqui"**.  

## Passo 2: Permitir a execução de scripts (se necessário)  
No PowerShell, execute o seguinte comando:  

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser


---

## **Notas Importantes**
- Certifique-se de fazer backup dos seus dados antes de realizar qualquer instalação ou configuração.  
- Este script foi otimizado para usuários que buscam melhorar a performance do Windows 11, especialmente para jogos.  

Caso tenha dúvidas ou sugestões, sinta-se à vontade para contribuir!  

--- 
