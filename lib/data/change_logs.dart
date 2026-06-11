import '../models/change_log_entry.dart';

const changeLogs = <ChangeLogEntry>[
  ChangeLogEntry(
    name: 'Maintainer',
    studentId: '2026000000',
    summary: 'Created the base project, three collaboration areas, and PR guide.',
    files: [
      'lib/main.dart',
      'lib/pages/hello_lab_page.dart',
      'lib/pages/tetris_page.dart',
      'lib/pages/change_log_page.dart',
    ],
  ),
  ChangeLogEntry(
    name: '赵林超',
    studentId: '12024215143',
    summary: '开发了小组协作 Flutter 项目的三个核心区域：Hello World 练习页、俄罗斯方块小游戏页和开发记录页，并完善了组员 fork 后提交 PR 的协作入口。',
    files: [
      'lib/main.dart',
      'lib/pages/hello_lab_page.dart',
      'lib/pages/tetris_page.dart',
      'lib/pages/change_log_page.dart',
      'lib/data/hello_entries.dart',
      'lib/data/change_logs.dart',
    ],
  ),

  ChangeLogEntry(
    name: '角明恒',
    studentId: '12024215176',
    summary: '在 Hello World 练习区添加了个人信息（姓名、学号、第一句问候语），并在开发记录区记录本次贡献内容。',
    files: [
      'lib/data/hello_entries.dart',
      'lib/data/change_logs.dart',
    ],
  ),

  // After finishing a feature, team members can copy this block and record
  // what they changed.
  //
  // ChangeLogEntry(
  //   name: 'Zhang San',
  //   studentId: '2026123456',
  //   summary: 'Added a new Tetris color theme and improved the score panel.',
  //   files: [
  //     'lib/pages/tetris_page.dart',
  //   ],
  // ),
];
