import shutil
import os

ignore = ("_MXCommon", "Airi0_home")


def copy(start, end):
    os.makedirs(os.path.dirname(end), exist_ok=True)
    print(f"{start} -> {end}")
    shutil.copy(start, end)


src = input("SpineLobbies>")
if not os.path.isdir(src):
    print("SpineLobbies directory not found")
    exit()

# path = input("VOC_JP(Optional)>")
# voc = path if os.path.isdir(path) else False

out = os.path.join(os.path.split(src)[0], "Lobbies")
path = input(f"Output(Default:[{out}])>")

if os.path.exists(os.path.dirname(path)):
    out = path
else:
    print("Use default output path")

for name in os.listdir(src):
    if name in ignore:
        continue
    root = os.path.join(src, name)
    name = name.lower()
    home = ""
    bg = []
    if not any("SkeletonData" in i for i in os.listdir(root)):
        for d in os.listdir(root):
            if "home" in d:
                home = d
            elif d not in {"Effects", "Texture"}:
                bg.append(os.path.join(root, d))
    out_path = os.path.join(out, name, name)
    for d in os.listdir(os.path.join(root, home)):
        if "home" not in d:
            continue
        file_name = os.listdir(os.path.join(root, home, d))[0]
        copy(os.path.join(root, home, d, file_name),
             os.path.join(out_path, file_name.lower()))
    for p in bg:
        for d in os.listdir(p):
            if not os.path.isdir(os.path.join(out, name, "bg", os.path.split(
                    p)[-1].lower())):
                os.makedirs(os.path.join(out, name, "bg", os.path.split(
                    p)[-1].lower()))
            file_name = os.listdir(os.path.join(p, d))[0]
            copy(os.path.join(p, d, file_name), os.path.join(out, name, "bg", os.path.split(
                p)[-1].lower(), file_name.lower()))
print("Done!")
