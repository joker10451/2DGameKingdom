from PIL import Image

head = Image.open('godot/assets/sprites/lpc_raw/head_heads_human_male_light.png').convert('RGBA')
hair = Image.open('godot/assets/sprites/lpc_raw/hair_bedhead_male_blonde.png').convert('RGBA')

# In LPC:
# Head size is (832, 2944)
# Hair size is (832, 1344)
# Row 10 (Down walk idle) is box: (0, 10*64, 64, 11*64) = (0, 640, 64, 704)
head_f0 = head.crop((0, 640, 64, 704))
hair_f0 = hair.crop((0, 640, 64, 704))

print("Head frame 0 bbox:", head_f0.getbbox())
print("Hair frame 0 bbox:", hair_f0.getbbox())

combo = Image.new("RGBA", (64, 64))
combo.alpha_composite(head_f0)
combo.alpha_composite(hair_f0)

combo_big = combo.resize((256, 256), Image.NEAREST)
combo_big.save("C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/test_head_plus_hair.png")
print("Saved test_head_plus_hair.png!")
