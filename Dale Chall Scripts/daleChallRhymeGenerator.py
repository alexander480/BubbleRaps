import json
import requests
import random

def load_words_from_json(file_path):
    """ Load words from a JSON file. """
    with open(file_path, 'r', encoding='utf-8') as file:
        words = json.load(file)
    return words

def fetch_rhymes(word, max_results=100):
    """ Fetch rhymes for a given word using the Datamuse API. """
    api_url = f"https://api.datamuse.com/words?rel_rhy={word}&max={max_results}"
    response = requests.get(api_url)
    if response.status_code == 200:
        return [item['word'] for item in response.json()]
    else:
        print(f"Failed to fetch rhymes: HTTP {response.status_code}")
        return []

def filter_words(rhymes, word_list):
    """ Filter rhymes to include only those also in the word list. """
    return [word for word in rhymes if word in word_list]

def main():
    # Path to the JSON file containing the Dale-Chall word list
    file_path = '/Users/awllwa/daleChallWordList_3LettersOrMore.json'
    
    # Load the Dale-Chall word list
    dale_chall_words = load_words_from_json(file_path)
    
    # Choose a random word from the list
    random_word = random.choice(dale_chall_words)
    print(f"Random word selected: {random_word}")
    
    # Fetch rhymes for the random word
    rhymes = fetch_rhymes(random_word)
    
    # Filter rhymes to include only those also in the Dale-Chall word list
    filtered_rhymes = filter_words(rhymes, dale_chall_words)
    
    # Output the filtered list of rhymes
    print(f"Filtered rhymes for '{random_word}': {filtered_rhymes}")

if __name__ == "__main__":
    main()
