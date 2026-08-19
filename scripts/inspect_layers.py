from PIL import Image

for name in ['body_bodies_male_light', 'head_heads_human_male_light', 'eyes_human_adult_blue', 'hair_bedhead_male_blonde', 'torso_chainmail_male_gray', 'torso_armour_plate_male_steel']:
    p = f"godot/assets/sprites/lpc_raw/{name}.png"
    im = Image.open(p)
    crop = im.crop((0, 640, 64, 704))
    bbox = crop.getbbox()
    crop.resize((256, 256), Image.NEAREST).save(f"C:/Users/Kriri/.gemini/antigravity/brain/5f6ab763-da43-4796-8dcb-d7e2dc2bb594/layer_{name}.png")
    print(f"{name}: size={im.size}, frame bbox={bbox}")
