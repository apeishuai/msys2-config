const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

function createOutputFolderIfNotExists() {
  const outputFolder = 'G:\\config and meta_data\\My-Easy-Pic-Bed-main\\pics';

  if (!fs.existsSync(outputFolder)) {
    fs.mkdirSync(outputFolder);
  }
}

function traverseFolder(folderPath) {
  const files = fs.readdirSync(folderPath);

  files.forEach((file) => {
    const filePath = path.join(folderPath, file);
    const fileStat = fs.statSync(filePath);

    if (fileStat.isDirectory()) {
      traverseFolder(filePath);
    } else if (fileStat.isFile() && path.extname(file).toLowerCase() === '.pdf') {
      const pdfFileName = path.basename(file, '.pdf');
      const newFolderPath = path.join('G:\\config and meta_data\\My-Easy-Pic-Bed-main\\pics', pdfFileName);

      if (!fs.existsSync(newFolderPath)) {
        fs.mkdirSync(newFolderPath);
        convertPDFToImages(filePath, newFolderPath);
      }
    }
  });
}

function convertPDFToImages(pdfFilePath, outputFolder) {
  const command = `mutool convert -o "${outputFolder}/%d.png" "${pdfFilePath}"`;

  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error('Error converting PDF to images:', error);
    } else {
      console.log(`PDF converted to images in ${outputFolder} successfully.`);
      createIndexFile(outputFolder);
    }
  });
}

function createIndexFile(outputFolder) {
  const images = fs.readdirSync(outputFolder)
    .filter(file => file.endsWith('.png'))
    .map(file => `<p><img src="${file}" alt="${file}"></p>`)
    .join('<hr>');

  const indexContent = `
    <html>
      <head>
        <title>Image Index</title>
      </head>
      <body>
        ${images}
      </body>
    </html>
  `;

  fs.writeFileSync(`${outputFolder}/index.html`, indexContent);

  console.log(`Index file created in ${outputFolder} successfully.`);
}

// 检测并创建目标文件夹
createOutputFolderIfNotExists();

// 继续执行遍历文件夹的操作
const inputFolder = 'G:\\ebooks\\mutool 2 png';
traverseFolder(inputFolder);
