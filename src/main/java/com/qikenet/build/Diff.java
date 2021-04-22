package com.qikenet.build;

import com.github.difflib.DiffUtils;
import com.github.difflib.UnifiedDiffUtils;
import com.github.difflib.patch.AbstractDelta;
import com.github.difflib.patch.Patch;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;

public class Diff {

    public static void main(String[] args) throws IOException {

        List<String> original = Files.readAllLines(new File("/Users/panjing/dev/mybatis-generator/src/main/java/com/qikenet/build/text1").toPath());
        List<String> revised = Files.readAllLines(new File("/Users/panjing/dev/mybatis-generator/src/main/java/com/qikenet/build/text2").toPath());
        Patch<String> patch = DiffUtils.diff(revised,original);
        for (AbstractDelta<String> delta : patch.getDeltas()) {
            System.out.println(delta);
            //delete 删除行
            //change 更新行
            //insert 增加
        }

    }
}
