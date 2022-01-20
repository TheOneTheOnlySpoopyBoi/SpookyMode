const pixel_scene_root_folder = './files/pixel_scenes';
const chunks = [
  [ -6, 0 ],
  [ -5, 0 ],
  [ -4, 0 ],
  [ -3, 0 ],
  [ -2, 0 ],
  [ -1, 0 ],
  [ 0, 0 ],
  [ -6, 1 ],
  [ -5, 1 ],
  [ -4, 1 ],
  [ -3, 1 ],
  [ -2, 1 ],
  [ -1, 1 ],
  [ 0, 1 ],
  [ -6, 2 ],
  [ -5, 2 ],
  [ -4, 2 ],
  [ -3, 2 ],
  [ -2, 2 ],
  [ -1, 2 ],
  [ 0, 2 ],
];

let extents = { minX: 0, maxX: 0, minY: 0, maxY: 0, width: 0, height: 0 };
chunks.forEach(chunk => {
  const [ x, y ] = chunk;
  extents.minX = Math.min(extents.minX, x);
  extents.maxX = Math.max(extents.maxX, x);
  extents.minY = Math.min(extents.minY, y);
  extents.maxY = Math.max(extents.maxY, y);
});
const size = { x: extents.maxX - extents.minX, y: extents.maxY - extents.minY };

document.body.style.setProperty("--num-tiles-x", size.x);
document.body.style.setProperty("--num-tiles-y", size.y);

const container = document.getElementById('container');

chunks.forEach(chunk => {
  const [ x, y, has_background, has_visual ] = chunk;
  const div = document.createElement('div');
  const span = document.createElement('span');

  span.innerText = `${x}_${y}.png`;
  span.style.setProperty('z-index', 4);
  div.style.setProperty('position', 'absolute');
  div.style.setProperty('left', (x - extents.minX) * 256 + 'px');
  div.style.setProperty('top', (y - extents.minY) * 256 + 'px');
  div.appendChild(span);

  const img = document.createElement('img');
  img.src = `./files/pixel_scenes/${x}_${y}.png`;
  img.style.setProperty('z-index', 1);

  if(has_background) {
    const img = document.createElement('img');
    img.src = `./files/pixel_scenes/${x}_${y}_background.png`;
    img.style.setProperty('z-index', 2);
    img.style.setProperty('opacity', 0.5);
    div.appendChild(img);
  }

  if(has_visual) {
    const img = document.createElement('img');
    img.src = `./files/pixel_scenes/${x}_${y}_visual.png`;
    img.style.setProperty('z-index', 3);
    div.appendChild(img);
  }

  div.appendChild(img);
  container.appendChild(div);
});
