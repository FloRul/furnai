﻿import base64
from PIL import Image
from io import BytesIO


# content_type = 'application/json;jpeg', endpoint expects payload to be a json with the original image and the mask image as bytes encoded with base64.b64 encoding.
# To send raw image to the endpoint, you can set content_type = 'application/json' and encoded_image as np.array(PIL.Image.open(input_img_file_name.jpg)).tolist()
content_type = "application/json;jpeg"


with open(input_img_file_name, "rb") as f:
    input_img_image_bytes = f.read()
with open(input_img_mask_file_name, "rb") as f:
    input_img_mask_image_bytes = f.read()

encoded_input_image = base64.b64encode(bytearray(input_img_image_bytes)).decode()
encoded_mask = base64.b64encode(bytearray(input_img_mask_image_bytes)).decode()


payload = {
    "prompt": "a white cat, blue eyes, wearing a sweater, lying in park",
    "image": encoded_input_image,
    "mask_image": encoded_mask,
    "num_inference_steps": 50,
    "guidance_scale": 7.5,
    "seed": 0,
    "negative_prompt": "poorly drawn feet",
}


# For accept = 'application/json;jpeg', endpoint returns the jpeg image as bytes encoded with base64.b64 encoding.
# To receive raw image with rgb value set Accept = 'application/json'
accept = "application/json;jpeg"

# Note that sending or receiving payload with raw/rgb values may hit default limits for the input payload and the response size.

query_response = query(model_predictor, json.dumps(payload).encode("utf-8"), content_type, accept)
generated_images = parse_response(query_response)


# For accept = 'application/json;jpeg' mentioned above, returned image is a jpeg as bytes encoded with base64.b64 encoding.
# Here, we decode the image and display the image.
for generated_image in generated_images:
    generated_image_decoded = BytesIO(base64.b64decode(generated_image.encode()))
    generated_image_rgb = Image.open(generated_image_decoded).convert("RGB")
    # You can save the generated image by calling generated_image_rgb.save('inpainted_image.jpg')
    display_img_and_prompt(generated_image_rgb, "Inpainted image generated by the model")