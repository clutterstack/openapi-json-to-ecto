#!/bin/bash

# Script to "manually" encode in changeset schemas when a field or embedded schema
# is required -- by editing the module file!
# This isn't idempotent btw and is obvs brittle.

# Hard-code which module files need which field to be required in the schema changeset
declare -a file_field_pairs=(
    "fly_schemas/fly_env_from.ex:env_var"
    "fly_schemas/fly_machine_secret.ex:env_var"
    "fly_schemas/fly_machine_config.ex:image"
    # Add more file:field pairs as needed
)

declare -a file_ref_pairs=(
    "fly_schemas/create_machine_request.ex:config"
    "fly_schemas/update_machine_request.ex:config"
    # Add more file:field pairs as needed
)

# Function to add the validation line to a file
add_validation() {
    local file="$1"
    local field="$2"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi

    # sed -i '' -e "/def changeset(schema, attrs) do/{N;/\n    schema/ a\\
    #     |> validate_required([:$field])
    # }" "$file"
    sed -i '' "/def changeset(schema, attrs) do/,/^[[:space:]]*end[[:space:]]*$/ {
    /^[[:space:]]*end[[:space:]]*$/ i\\
    |> validate_required([:$field])
}" "$file"

    # Check if sed command was successful
    if [ $? -ne 0 ]; then
        echo "Error: sed command failed for $file"
        rm "$temp_file"
        return 1
    fi

    echo "Processed $file"
}

# Function to add the validation line to a file
add_image_requirement() {
    local file="$1"
    local field="$2"
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi
    # Need to replace
    #        |> cast_embed(:config, with: &FlyApi.FlyMachineConfig.changeset/2)
    # with
    #        |> cast_embed(:config, [:required, with: &FlyApi.FlyMachineConfig.changeset/2])

    sed -i '' -e 's/with: \&FlyApi.FlyMachineConfig.changeset\/2)/[:required, with: \&FlyApi.FlyMachineConfig.changeset\/2])/' "$file"

    # Check if sed command was successful
    if [ $? -ne 0 ]; then
        echo "Error: sed command failed for $file"
        rm "$temp_file"
        return 1
    fi
}

# Main script
echo "Starting to process files..."

for pair in "${file_field_pairs[@]}"; do
    IFS=':' read -r file field <<< "$pair"
    if add_validation "$file" "$field"; then
        echo "Successfully added validation for :$field to $file"
    else
        echo "Failed to process $file"
    fi
done

for pair in "${file_ref_pairs[@]}"; do
    IFS=':' read -r file field <<< "$pair"
    if add_image_requirement "$file" "$field"; then
        echo "Successfully added validation for :$field to $file"
    else
        echo "Failed to process $file"
    fi
done

echo "All files processed."