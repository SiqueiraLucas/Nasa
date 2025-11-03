# 🚀 Nasa App

Aplicativo iOS que consome a [NASA Astronomy Picture of the Day API (APOD)](https://api.nasa.gov/), exibindo a foto do dia, uma lista de imagens anteriores e um gerenciador de favoritos, construído com **Arquitetura modular**, **SwiftUI** e **MVVM**.

---

## 🧩 Arquitetura

O projeto segue o padrão **MVVM (Model - View - ViewModel)** com:
- Separação clara de responsabilidades  
- Facilidade de manutenção  
- Testabilidade 

### 🗂 Estrutura Modular

O app é **modularizado**, com injeção de dependências entre os módulos:

| Módulo | Responsabilidade |
|--------|------------------|
| **Network** | Comunicação com APIs e persistência local via Core Data. |
| **UI** | Componentes visuais reutilizáveis (Views, Botões, Inputs, etc). |
| **Utils** | Funções auxiliares e extensões reutilizáveis entre os módulos. |
| **Picture** | Módulo de features (contém as telas e seus ViewModels). |

---

## 📱 Telas do módulo `Picture`

| Tela | Descrição |
|------|------------|
| **Home** | Tela inicial com a **foto do dia**, uma **prévia dos favoritos**, e uma seção de **outras fotos**. |
| **Detalhe da Foto** | Exibe informações completas da imagem selecionada. |
| **Favoritos** | Lista todas as imagens salvas como favoritas. |

---

## 🧪 Testes

As telas do módulo NasaPicture possuem **testes unitários** implementados com `XCTest`
- Cobertura dos fluxos principais  
- Testes de ViewModels  
- Mocks e Spies para `DataProvider` e `Coordinator`  

Os testes devem ser executados no Package do módulo:
```
⌘ + U
```

---

## ⚙️ Gerenciador de Dependências

O projeto utiliza **Swift Package Manager (SPM)**.

As dependências são resolvidas automaticamente ao abrir o projeto no Xcode.

---

## 🔑 Como testar o app

1. Acesse o arquivo:

   ```
   AppConfig.swift
   ```

2. Localize a constante:
   ```swift
   static let apiKey = "YOUR_DEMO_KEY"
   ```

3. Substitua `"YOUR_DEMO_KEY"` pela sua **chave de API da NASA**, obtida gratuitamente em:  
   👉 [https://api.nasa.gov](https://api.nasa.gov)

4. Execute o projeto normalmente.

---

## 💡 Tecnologias Utilizadas

- **SwiftUI** — construção das interfaces de usuário  
- **Combine** — reatividade e binding de estados  
- **Core Data** — persistência local de favoritos  
- **PromiseKit** — tratamento assíncrono elegante  
- **XCTest** — testes unitários  
- **SPM** — gerenciamento de dependências  

---

## 📦 Estrutura Simplificada

```
Nasa/
├── Nasa
│   ├── App
│   │   ├──AppConfig.swift
│   │   ├──NasaApp.swift
│   ├── Resources
├── Modules/
│   ├── Network/
│   │   ├── DataClient.swift
│   │   └── HTTPClient.swift
│   ├── UI/
│   │   ├── URLImage.swift
│   │   └── FavoriteButtonView.swift
│   ├── Utils/
│   │   ├── Date+Extensions.swift
│   │   └── String+Extensions.swift
│   └── Picture/
│       ├── Home/
│       │   ├── HomeView.swift
│       │   ├── HomeModel.swift
│       │   └── HomeViewModel.swift
│       ├── PictureDetail/
│       ├── Favorite/
└─
```

---

## 🛰 Autor

**Lucas Siqueira**  
Desenvolvedor iOS  
💼 [LinkedIn](https://www.linkedin.com/in/lucassiqueiradev/)
