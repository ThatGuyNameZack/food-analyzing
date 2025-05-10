import os
from pathlib import Path

# Define the folder paths
image_folder = Path('food_images')
annotation_folder = Path('food_nutrisi')

# List all images in the food_images folder, including subfolders
image_files = []
for root, dirs, files in os.walk(image_folder):
    for file in files:
        if file.endswith('.jpg') or file.endswith('.png'):
            image_files.append(Path(root) / file)

for image_file in image_files:
    annotation_file = annotation_folder / f"{image_file.stem}.txt"  # Assuming annotations have same name but .txt extension
    
    if annotation_file.exists():
        # Process the image and annotation here
        print(f"Processing {image_file} with annotation {annotation_file}")
        
print(f"Image folder path: {image_folder}")
print(f"Annotation folder path: {annotation_folder}")
print(f"Image files: {image_files}")
