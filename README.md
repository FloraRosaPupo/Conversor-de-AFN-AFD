# Simulador de Autômatos Finitos e Máquina de Turing

## Descrição

Aplicativo Flutter com serviços Python/Flask para simular autômatos finitos, converter AFN em AFD e executar máquinas de Turing com limite de passos. A minimização de AFD não está implementada e retorna erro explícito.

## Stack e bibliotecas

Flutter/Dart, http, Python, Flask e flask-cors.

Dependências e versões declaradas: [automato_app/pubspec.yaml](automato_app/pubspec.yaml), [automato_app/service/requirements.txt](automato_app/service/requirements.txt).

## Funcionalidades

- Simulação de AFD/AFN.
- Determinização.
- Máquina de Turing com limite de passos.

## Licença

Não há uma licença de distribuição definida para este repositório. Nenhuma licença MIT, Apache ou equivalente é concedida por este README. As atribuições e os direitos dos materiais de terceiros permanecem preservados.

## Validação e limites

Validação e conversão da API e interação do formulário com HTTP simulado. APIs reais usam portas/configuração documentadas.

## Guia de entradas e simulação

A interface reúne duas áreas de simulação:

1. **Simulador de Máquina de Turing**

   Um aplicativo Flutter que permite simular o processamento de uma Máquina de Turing, um modelo teórico fundamental usado para entender os limites da computabilidade e simular algoritmos complexos. A Máquina de Turing é uma máquina abstrata que opera em uma fita infinita dividida em células, onde lê e escreve símbolos de acordo com um conjunto de regras definidas.

   **Funcionalidades**
   - **Simulação da Máquina de Turing**: Simula o processamento de uma fita conforme as regras e configurações fornecidas.
   - **Avaliação de Aceitação/Rejeição**: Avalia se a máquina aceita ou rejeita uma entrada com base na configuração e regras de transição fornecidas.
   - **Visualização das Transições**: Exibe as transições realizadas durante a simulação.

   **Tecnologias Utilizadas**
   - **Frontend**: Flutter
   - **Backend**: Flask

   **Entradas**
   - **Estados**: Liste os estados da Máquina de Turing, separados por espaço.
   - **Alfabeto da Fita**: Defina o alfabeto dos símbolos que podem aparecer na fita, separados por espaço.
   - **Alfabeto de Entrada**: Defina o alfabeto dos símbolos de entrada, separados por espaço.
   - **Marcador de Início da Fita**: Informe o símbolo que indica o início da fita.
   - **Símbolo Vazio da Fita**: Informe o símbolo que representa uma célula vazia na fita.
   - **Transições**: Descreva as regras de transição no formato `estado,símbolo,novo estado,nova escrita,movimento`, separadas por `;`.
   - **Estado Inicial**: Informe o estado inicial da Máquina de Turing.
   - **Fita Inicial**: Informe o conteúdo inicial da fita.
   - **Estados Finais**: Liste os estados de aceitação, separados por espaço.

   **Funcionamento**
   O simulador de Máquina de Turing usa uma interface Flutter para coleta de dados e um backend Flask para processamento. A entrada é fornecida por meio de campos de texto na interface Flutter e enviada para o backend em formato JSON. O backend executa a simulação de acordo com as regras definidas e retorna o resultado, incluindo o estado final da fita, o estado final da máquina e uma lista das transições realizadas durante a simulação.

2. **Simulador de Autômatos Finitos (AFD/AFN)**

   Um aplicativo Flutter que simula Autômatos Finitos Determinísticos (AFD) e Não Determinísticos (AFN). Este simulador permite avaliar se uma palavra é aceita ou rejeitada por um autômato finito com base nas configurações e regras fornecidas.

   **Funcionalidades**
   - **Simulação de AFD/AFN**: Simula AFD ou AFN com base nos dados inseridos.
   - **Avaliação de Palavras**: Exibe se cada palavra é aceita ou rejeitada pelo autômato.
   - **Minimização de AFD**: não implementada; a API retorna erro explícito.

   **Tecnologias Utilizadas**
   - **Frontend**: Flutter
   - **Backend**: Flask

   **Entradas**
   - **Tipo de Autômato**: Especifique se o autômato é AFD ou AFN.
   - **Estados**: Liste os estados do autômato, separados por espaço.
   - **Alfabeto**: Defina o alfabeto do autômato, separado por espaço.
   - **Transições**: Descreva as transições no formato `estado,símbolo,próximo estado`, separadas por espaço.
   - **Estado Inicial**: Informe o estado inicial.
   - **Estados de Aceitação**: Liste os estados de aceitação, separados por espaço.
   - **Palavras para Simulação**: Informe as palavras a serem simuladas, separadas por espaço.
   - **Minimizar AFD**: mantenha desmarcado; essa operação não está implementada.

   **Funcionamento**
   O simulador de Autômatos Finitos usa uma interface Flutter para coleta de dados e um backend Flask para processamento. A entrada é fornecida por meio de campos de texto na interface Flutter e enviada para o backend em formato JSON. O backend processa as informações e retorna os resultados da simulação, indicando se cada palavra foi aceita ou rejeitada A minimização não é executada.

Ambos os aplicativos permitem observar e entender o comportamento desses modelos teóricos ao simular diferentes configurações e entradas, proporcionando uma visão prática dos conceitos de automação e computabilidade.

## Desenvolvimento e validação

O aplicativo está em `automato_app`. Use Flutter 3.41.1. Na pasta do aplicativo, execute:

```sh
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter run
```

A CI valida análise e testes em pushes e pull requests. Serviços externos precisam de configuração própria.

## Serviços Python

Use Python 3.11+ e, na pasta `automato_app/service`, execute `python -m pip install -r requirements.txt`. Inicie `python automato_service.py` (porta 5000) e `python maquina_service.py` (porta 5001) em terminais separados. Configure as URLs do aplicativo de acordo com o dispositivo; localhost no emulador não é o computador hospedeiro.

Execute `python -m unittest discover -s tests -v` nessa pasta. A conversão AFN aceita múltiplos destinos por transição; minimização ainda não está implementada e retorna erro explícito. A máquina de Turing limita a execução a 10000 passos. Não há suporte a transições epsilon no conversor.

## Organização e manutenção

Interfaces de autômatos e Turing foram separadas em features; seleção fica em app. Serviços Python são processos separados e o cliente HTTP da tela é substituível. Minimização não implementada responde erro explícito.

Veja [a revisão de desenvolvimento](docs/REVISAO.md) para decisões, testes e limites, e [o guia de contribuição](CONTRIBUTING.md) para o fluxo de manutenção.
