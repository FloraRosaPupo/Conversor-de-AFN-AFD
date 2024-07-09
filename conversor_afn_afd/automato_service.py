from flask import Flask, request, jsonify
import json
from flask_cors import CORS
app = Flask(__name__)
CORS(app)  # Habilita CORS para todas as rotas
app = Flask(__name__)

class Automaton:
    def __init__(self, states, alphabet, transition_function, start_state, accept_states):
        self.states = states
        self.alphabet = alphabet
        self.transition_function = transition_function
        self.start_state = start_state
        self.accept_states = accept_states
    
    def simulate(self, word):
        current_state = self.start_state
        for symbol in word:
            if (current_state, symbol) in self.transition_function:
                current_state = self.transition_function[(current_state, symbol)]
            else:
                return "rejeitada"
        return "aceita" if current_state in self.accept_states else "rejeitada"

def afn_to_afd(afn):
    # Implement your AFN to AFD conversion logic here
    pass

def check_equivalence(afn, afd, words):
    # Implement your equivalence checking logic here
    pass

@app.route('/simulate', methods=['POST'])
def simulate():
    data = request.json
    automaton_type = data.get('automaton_type')
    states = data.get('states')
    alphabet = data.get('alphabet')
    transitions = data.get('transitions')
    start_state = data.get('start_state')
    accept_states = data.get('accept_states')
    words = data.get('words')

    states = set(states)
    alphabet = set(alphabet)
    transition_function = {}
    for t in transitions:
        state, symbol, next_state = t.split(',')
        if (state, symbol) not in transition_function:
            transition_function[(state, symbol)] = next_state
        else:
            transition_function[(state, symbol)] += "," + next_state

    accept_states = set(accept_states)

    if automaton_type == 'AFD':
        automaton = Automaton(states, alphabet, transition_function, start_state, accept_states)
    elif automaton_type == 'AFN':
        automaton = Automaton(states, alphabet, transition_function, start_state, accept_states)
    else:
        return jsonify({"error": "Tipo de autômato inválido. Use 'AFD' ou 'AFN'."})

    results = {}
    for word in words:
        results[word] = automaton.simulate(word)

    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)
