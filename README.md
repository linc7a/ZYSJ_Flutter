# ZYSJ Flutter 小组协作项目

这是一个用于课程小组协作练习的 Flutter 项目。项目已经拆成三个功能区域，组员可以 fork 仓库后在自己的分支中继续开发，然后通过 Pull Request 提交贡献。

## 当前本地运行地址

开发服务启动后访问：

```text
http://127.0.0.1:8080
```

## 项目功能

### 1. Hello World 练习区

文件：

- 页面：`lib/pages/hello_lab_page.dart`
- 数据：`lib/data/hello_entries.dart`

用途：

每位组员添加自己的姓名、学号和第一句 Hello World，用来练习最基础的 Flutter 数据展示和 PR 提交流程。

### 2. 俄罗斯方块小游戏区

文件：

- 页面：`lib/pages/tetris_page.dart`

当前功能：

- 方块自动下落
- 左右移动
- 旋转
- 快速下落
- 消行计分
- 开始、暂停、重置

后续可继续开发：

- 增加难度等级
- 增加下一块预览
- 增加排行榜
- 优化颜色主题
- 增加键盘控制

### 3. 开发记录区

文件：

- 页面：`lib/pages/change_log_page.dart`
- 数据：`lib/data/change_logs.dart`

用途：

组员完成开发后，在这里写清楚自己做了什么、修改了哪些文件，方便老师和维护者查看每个人的贡献。

## 本地运行

确认已经安装 Flutter 后，在项目根目录执行：

```bash
flutter pub get
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

如果本机没有配置 Flutter 到 PATH，可以使用完整路径，例如：

```powershell
D:\dir\other\flutter_windows_3.44.1-stable\flutter\bin\flutter.bat pub get
D:\dir\other\flutter_windows_3.44.1-stable\flutter\bin\flutter.bat run -d web-server --web-hostname 127.0.0.1 --web-port 8080
```

## 组员如何提交贡献

1. 打开 GitHub 仓库并点击 `Fork`
2. 克隆自己 fork 后的仓库

```bash
git clone https://github.com/你的GitHub用户名/ZYSJ_Flutter.git
cd ZYSJ_Flutter
```

3. 新建自己的分支

```bash
git checkout -b add-your-contribution
```

4. 添加 Hello World 信息

打开 `lib/data/hello_entries.dart`，复制一段 `HelloEntry`，改成自己的信息：

```dart
HelloEntry(
  name: '张三',
  studentId: '12024210000',
  message: '我的第一个 hello world',
),
```

5. 开发或完善功能

可以选择继续开发俄罗斯方块，也可以完善页面样式、交互、数据展示等内容。

6. 添加开发记录

打开 `lib/data/change_logs.dart`，写清楚自己做了什么：

```dart
ChangeLogEntry(
  name: '张三',
  studentId: '12024210000',
  summary: '增加了俄罗斯方块的键盘控制功能，并优化了按钮布局。',
  files: [
    'lib/pages/tetris_page.dart',
    'lib/data/change_logs.dart',
  ],
),
```

7. 提交并推送

```bash
git add .
git commit -m "Add Zhang San contribution"
git push origin add-your-contribution
```

8. 回到 GitHub，点击 `Compare & pull request` 提交 PR。

## PR 要求

- 不删除其他组员的信息
- 每个组员单独提交一个 PR
- 必须在 `lib/data/change_logs.dart` 写开发记录
- 如果只添加个人 Hello World，优先只修改 `lib/data/hello_entries.dart` 和 `lib/data/change_logs.dart`
- 如果修改俄罗斯方块，请在开发记录中写清楚具体功能

## 维护者合并流程

收到 PR 后建议执行：

```bash
flutter analyze
flutter test
```

检查通过后再合并 PR。

## 当前贡献记录

- 赵林超 `12024215143`：开发了 Hello World 练习页、俄罗斯方块小游戏页、开发记录页，并完善了组员 fork 后提交 PR 的协作入口。
