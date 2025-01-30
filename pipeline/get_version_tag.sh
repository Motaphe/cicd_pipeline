#!/bin/bash

# Use curl to fetch the data 
get_response() {
    response=$(curl -X GET \
        "https://$DOCKER_REGISTRY/api/v2.0/projects/$DOCKER_PROJECT/repositories/$DOCKER_REPO/artifacts" \
        -H 'accept: application/json' \
        -H "authorization: Basic $HARBOR_USER_TOKEN")
    echo "$response"
}

increment_version() {
    version="$1"
    IFS='.' read -r major minor patch <<< "$version"

    # Increment patch
    patch=$((patch + 1))
    if [ "$patch" -gt 9 ]; then
        patch=0
        minor=$((minor + 1))  # Increment minor when patch rolls over
    fi

    # Increment minor
    if [ "$minor" -gt 9 ]; then
        minor=0
        major=$((major + 1))  # Increment major when minor rolls over
    fi

    # Output the new version
    echo "$major.$minor.$patch"
}

get_version() {
    response=$(get_response)

    # Check if the response is literally an empty JSON array
    if [[ "$response" == "[]" ]]; then
        new_version="0.0.1"
        echo "$new_version"
    else
        # Extract all tag names by searching for "name": "something"
        old_version=$(echo "$response" \
            | grep -o '"name":[[:space:]]*"[^"]*"' \
            | cut -d'"' -f4 \
            | sort -V \
            | tail -n 1)

        # If no tags found in the JSON, default to 0.0.1
        if [ -z "$old_version" ]; then
            new_version="0.0.1"
        else
            new_version=$(increment_version "$old_version")
        fi
        echo "$new_version"
    fi
}

get_version
