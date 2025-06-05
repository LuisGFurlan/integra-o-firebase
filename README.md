# 🔐 Projeto: Autenticação e Upload com Firebase no Flutter

## 🎯 Objetivo Geral

Desenvolver um aplicativo mobile com Flutter e Firebase para:

- Autenticação de usuários via e-mail e senha
- Upload de imagem (câmera ou galeria)
- Armazenamento da imagem no Firebase Storage
- Salvamento do caminho da imagem no Cloud Firestore
- Acesso controlado com tela protegida após login

---

## 🖥️ Telas e Funcionalidades

### 🔑 Tela de Login

- Campos: **E-mail**, **Senha**
- Validações:
  - E-mail válido
  - Senha mínima de 6 caracteres
- Botões:
  - **Entrar** (valida e acessa se autenticado)
  - **Criar conta** (redireciona para tela de cadastro)
- Exibe erros de autenticação com mensagens amigáveis

### 📝 Tela de Cadastro

- Campos: **E-mail**, **Senha**
- Ao criar a conta:
  - Login imediato (ou controlado por parâmetro)
  - UID salvo no Firebase
  - Redireciona para a tela protegida

### 🧾 Tela Principal (Apenas usuários logados)

- Exibe e-mail do usuário autenticado
- Botão para selecionar imagem:
  - Escolher da **galeria**
  - Tirar com **câmera**
- Após imagem selecionada:
  - Mostra **preview**
  - Botão **Salvar no Firebase**
    - Upload no **Firebase Storage**
    - Salva URL da imagem no **Firestore**
    - Exibe mensagem de sucesso/erro

### 🚪 Logout

- Botão para **sair da conta**
- Redireciona para tela de login

---

## 🧾 Regras de Negócio

- Apenas usuários autenticados acessam a tela principal
- Validação obrigatória nos campos de login/cadastro
- Armazenamento da imagem associada ao UID do usuário
- Uso de permissões específicas para câmera e galeria
- Possibilidade de bloquear login automático após cadastro

---

## 📁 Estrutura de Pastas

- `/screens` → Telas do app (Login, Cadastro, Principal)
- `/services` → Código de autenticação e Firebase
- `/widgets` → Componentes reutilizáveis
- `main.dart` → Inicialização do app, rotas, Firebase init

---

## ☁️ Tecnologias e Ferramentas

- **Flutter SDK** (>= 3.x)
- **Dart**
- **Firebase**:
  - `firebase_auth` (autenticação)
  - `firebase_core` (inicialização)
  - `cloud_firestore` (armazenamento de dados)
  - `firebase_storage` (armazenamento de imagem)
- **image_picker** (seleção da imagem)
- **camera** (opcional)

