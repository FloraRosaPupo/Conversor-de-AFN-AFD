from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/simulate', methods=['POST'])
def simulate():
    data = request.get_json()

    # Verificar se os dados foram recebidos corretamente
    print("Received data:", data)

    states = data.get('states', [])
    alphabet = data.get('alphabet', [])
    transitions = data.get('transitions', [])
    initial_state = data.get('initial_state', '')
    tape = list(data.get('tape', ''))
    final_states = data.get('final_states', [])

    print("States:", states)
    print("Alphabet:", alphabet)
    print("Transitions:", transitions)
    print("Initial State:", initial_state)
    print("Tape:", tape)
    print("Final States:", final_states)

    current_state = initial_state
    head_position = 0

    while current_state not in final_states:
        if head_position < 0 or head_position >= len(tape):
            return jsonify({'error': 'Cabeça fora dos limites da fita'})

        current_symbol = tape[head_position]
        transition_found = False

        print(f"Current State: {current_state}, Symbol: {current_symbol}")

        for transition in transitions:
            try:
                state, symbol, new_state, new_symbol, movement = transition.split(',')
                print(f"Checking transition: {transition}")

                # Adicionar prints para verificar as comparações
                print(f"Comparing state: {state} with {current_state}")
                print(f"Comparing symbol: {symbol} with {current_symbol}")

                if state == current_state and symbol == current_symbol:
                    tape[head_position] = new_symbol
                    current_state = new_state
                    head_position += 1 if movement == 'R' else -1
                    transition_found = True
                    print(f"Transition applied: {state}, {symbol} -> {new_state}, {new_symbol}, {movement}")
                    break
            except ValueError as e:
                print(f"Error processing transition: {transition} - {e}")

        if not transition_found:
            return jsonify({'error': 'Nenhuma transição válida encontrada'})

    # Depuração: Imprimir o estado final e a fita final antes de retornar
    print("Final State:", current_state)
    print("Final Tape:", ''.join(tape))

    return jsonify({'final_tape': ''.join(tape), 'final_state': current_state})

if __name__ == '__main__':
    app.run(debug=True)

