import os
from PIL import Image, ImageOps

PC_ROOT = "temp_pixel_crawler/Pixel Crawler - Free Pack"
OUT_NPCS = "godot/assets/sprites/npcs"
OUT_SPRITES = "godot/assets/sprites"
os.makedirs(OUT_NPCS, exist_ok=True)

def build_4dir_sheet(down_path, side_path, up_path, out_path, frame_w=64, frame_h=64, num_frames=6):
    im_down = Image.open(down_path).convert("RGBA")
    im_side = Image.open(side_path).convert("RGBA")
    im_up = Image.open(up_path).convert("RGBA")
    
    # 4 rows: Row 0 = Up, Row 1 = Left (Side flipped), Row 2 = Down, Row 3 = Right (Side)
    sheet = Image.new("RGBA", (frame_w * num_frames, frame_h * 4), (0, 0, 0, 0))
    
    for f in range(num_frames):
        # Up
        frame_u = im_up.crop((f * frame_w, 0, (f + 1) * frame_w, frame_h))
        sheet.paste(frame_u, (f * frame_w, 0 * frame_h), frame_u)
        
        # Left (Flipped horizontally)
        frame_s = im_side.crop((f * frame_w, 0, (f + 1) * frame_w, frame_h))
        frame_l = ImageOps.mirror(frame_s)
        sheet.paste(frame_l, (f * frame_w, 1 * frame_h), frame_l)
        
        # Down
        frame_d = im_down.crop((f * frame_w, 0, (f + 1) * frame_w, frame_h))
        sheet.paste(frame_d, (f * frame_w, 2 * frame_h), frame_d)
        
        # Right (Side)
        sheet.paste(frame_s, (f * frame_w, 3 * frame_h), frame_s)
        
    sheet.save(out_path)
    print("Saved 4-direction spritesheet:", out_path)

# 1. Player Body_A
build_4dir_sheet(
    f"{PC_ROOT}/Entities/Characters/Body_A/Animations/Walk_Base/Walk_Down-Sheet.png",
    f"{PC_ROOT}/Entities/Characters/Body_A/Animations/Walk_Base/Walk_Side-Sheet.png",
    f"{PC_ROOT}/Entities/Characters/Body_A/Animations/Walk_Base/Walk_Up-Sheet.png",
    f"{OUT_SPRITES}/player_walk_cycle.png"
)

# 2. Peasant Female / Citizen
# Peasant_A has Walk-Sheet.png (384x64)
# Let's create a single-sheet 4-dir wrapper
def build_from_single_run(single_path, out_path, frame_w=64, frame_h=64, num_frames=6):
    im = Image.open(single_path).convert("RGBA")
    sheet = Image.new("RGBA", (frame_w * num_frames, frame_h * 4), (0, 0, 0, 0))
    for f in range(num_frames):
        frame = im.crop((f * frame_w, 0, (f + 1) * frame_w, frame_h))
        frame_l = ImageOps.mirror(frame)
        sheet.paste(frame, (f * frame_w, 0 * frame_h), frame) # Up
        sheet.paste(frame_l, (f * frame_w, 1 * frame_h), frame_l) # Left
        sheet.paste(frame, (f * frame_w, 2 * frame_h), frame) # Down
        sheet.paste(frame, (f * frame_w, 3 * frame_h), frame) # Right
    sheet.save(out_path)
    print("Saved from single run:", out_path)

build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Citizen_F/Peasant_A/Walk/Walk-Sheet.png", f"{OUT_NPCS}/npc_peasant_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Citizen_F/Tavern_A/Walk/Walk_Side-Sheet.png", f"{OUT_NPCS}/npc_merchant_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Knight/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_guard.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Knight/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_guard_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Knight/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_blacksmith.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Knight/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_blacksmith_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Rogue/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_bandit.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Rogue/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_bandit_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Wizzard/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_lord.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Wizzard/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_lord_female.png")
build_from_single_run(f"{PC_ROOT}/Entities/Npc's/Wizzard/Run/Run-Sheet.png", f"{OUT_NPCS}/npc_merchant.png")
build_from_single_run(f"{PC_ROOT}/Entities/Characters/Body_A/Animations/Walk_Base/Walk_Down-Sheet.png", f"{OUT_NPCS}/npc_peasant_male.png")

print("All Pixel Crawler character sheets built successfully!")
