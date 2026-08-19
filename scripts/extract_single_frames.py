from PIL import Image

# Check what was in player_walk_cycle.png
im = Image.open('godot/assets/sprites/player_walk_cycle.png')
print("player_walk_cycle.png size:", im.size)

# Let's inspect the first frame of each row (Down, Up, Left, Right)
down_frame = im.crop((0, 0, 64, 64))
down_frame.save('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_down_single.png')

up_frame = im.crop((0, 64, 64, 128))
up_frame.save('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_up_single.png')

left_frame = im.crop((0, 128, 64, 192))
left_frame.save('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_left_single.png')

right_frame = im.crop((0, 192, 64, 256))
right_frame.save('C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/hero_right_single.png')

print("Single frames saved to artifacts directory.")
