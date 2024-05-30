import json
import random

def load_json_file(file_path):
    """ Load data from a JSON file. """
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)

def save_json_file(data, file_path):
    """ Save data to a JSON file. """
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4)

def update_word_packs(word_packs, all_words):
    """ Update word packs with notRhymes, update rhymeDictionary and allWords properties. """
    for pack in word_packs:
        # Find words not in rhymes
        not_rhymes = random.sample([word for word in all_words if word not in pack['rhymes']], 10)
        pack['notRhymes'] = not_rhymes
        
        # Update rhymeDictionary with false values for not rhymes
        for word in not_rhymes:
            pack['rhymeDictionary'][word] = False
        
        # Append notRhymes to allWords
        pack['allWords'].extend(not_rhymes)

def main():
    # Paths to the files
    packs_file_path = '/Users/awllwa/daleChallWordPacks.json'
    word_list_file_path = '/Users/awllwa/daleChallWordList_3LettersOrMore.json'
    
    # Load data from files
    word_packs = load_json_file(packs_file_path)
    dale_chall_words = load_json_file(word_list_file_path)
    
    # Update word packs
    update_word_packs(word_packs, dale_chall_words)
    
    # Save the updated word packs to a new file
    updated_packs_file_path = '/Users/awllwa/CompletedDaleChallWordPacks.json'
    save_json_file(word_packs, updated_packs_file_path)
    print(f"Updated word packs saved to {updated_packs_file_path}")

if __name__ == "__main__":
    main()
