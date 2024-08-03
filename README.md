Simulador de AFD/AFN
Um aplicativo Flutter para simulação de Autômatos Finitos Determinísticos (AFD) e Não Determinísticos (AFN).

Funcionalidades
- Simula AFD/AFN com dados inseridos.
- Exibe se cada palavra é aceita ou rejeitada.
- Opção de minimizar o AFD.
  
Tecnologias Utilizadas
- Frontend: Flutter
- Backend: Flask
  
Entradas
- Tipo de Autômato: Especifique se o autômato é AFD ou AFN.
- Estados: Liste os estados do autômato, separados por espaço.
- Alfabeto: Defina o alfabeto do autômato, separado por espaço.
- Transições: Descreva as transições no formato estado,símbolo,próximo estado, separados por espaço.
- Estado Inicial: Informe o estado inicial.
- Estados de Aceitação: Liste os estados de aceitação, separados por espaço.
- Palavras para Simulação: Informe as palavras a serem simuladas, separadas por espaço.
- Minimizar AFD: Marque a opção se desejar minimizar o AFD (apenas para autômatos determinísticos).
