import yaml

def update_yaml_value(file_path, key_path, value):
    with open(file_path, "r") as file:
        data = yaml.safe_load(file)

    keys = key_path.split(".")

    current = data

    # Navigate to the parent of the target key
    for key in keys[:-1]:
        if key not in current:
            raise KeyError(f"Key '{key}' does not exist in YAML")
        current = current[key]

    # Update only an existing key
    final_key = keys[-1]

    if final_key not in current:
        raise KeyError(f"Key '{final_key}' does not exist in YAML")

    current[final_key] = value

    with open(file_path, "w") as file:
        yaml.safe_dump(data, file, sort_keys=False)
