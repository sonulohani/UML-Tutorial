#!/bin/bash

# UML Tutorial - Diagram Generation Script
# This script generates PNG images from all PlantUML files in the tutorial

echo "🎨 UML Tutorial - Diagram Generator"
echo "=================================="

# Check if PlantUML jar exists
if [ ! -f "plantuml.jar" ]; then
    echo "📥 PlantUML jar not found. Downloading..."
    wget -q http://sourceforge.net/projects/plantuml/files/plantuml.jar/download -O plantuml.jar
    if [ $? -eq 0 ]; then
        echo "✅ PlantUML jar downloaded successfully"
    else
        echo "❌ Failed to download PlantUML jar"
        echo "Please download manually from: http://plantuml.com/download"
        exit 1
    fi
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed or not in PATH"
    echo "Please install Java 8 or higher"
    exit 1
fi

# Create images directory
mkdir -p images
echo "📁 Created images directory"

# Generate diagrams from examples directory
if [ -d "examples" ]; then
    echo "🔄 Generating diagrams from examples directory..."
    for file in examples/*.puml; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .puml)
            echo "  📊 Generating $filename.png..."
            java -jar plantuml.jar -o ../images "$file"
            if [ $? -eq 0 ]; then
                echo "  ✅ Generated images/$filename.png"
            else
                echo "  ❌ Failed to generate $filename.png"
            fi
        fi
    done
else
    echo "⚠️  Examples directory not found"
fi

# Generate any .puml files in the root directory
echo "🔄 Checking for PlantUML files in root directory..."
puml_count=0
for file in *.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file" .puml)
        echo "  📊 Generating $filename.png..."
        java -jar plantuml.jar -o ./images "$file"
        if [ $? -eq 0 ]; then
            echo "  ✅ Generated images/$filename.png"
            ((puml_count++))
        else
            echo "  ❌ Failed to generate $filename.png"
        fi
    fi
done

if [ $puml_count -eq 0 ] && [ ! -d "examples" ]; then
    echo "⚠️  No PlantUML files found"
fi

# Generate SVG versions for better quality
echo "🔄 Generating SVG versions for better quality..."
mkdir -p images/svg

if [ -d "examples" ]; then
    for file in examples/*.puml; do
        if [ -f "$file" ]; then
            filename=$(basename "$file" .puml)
            echo "  🎨 Generating $filename.svg..."
            java -jar plantuml.jar -tsvg -o ../images/svg "$file"
        fi
    done
fi

for file in *.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file" .puml)
        echo "  🎨 Generating $filename.svg..."
        java -jar plantuml.jar -tsvg -o ./images/svg "$file"
    fi
done

echo ""
echo "🎉 Diagram generation complete!"
echo "📁 PNG images are in: ./images/"
echo "📁 SVG images are in: ./images/svg/"
echo ""
echo "💡 Tips:"
echo "   - PNG files are good for documentation"
echo "   - SVG files are scalable and good for presentations"
echo "   - You can view the images in any image viewer or web browser"
echo ""
echo "🔗 To learn more about PlantUML, see: setup-plantuml.md" 