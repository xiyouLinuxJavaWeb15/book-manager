package bookmanager.web.loginandunlogin;

import bookmanager.dao.dbservice.BookInfoService;
import bookmanager.dao.dbservice.BookLabelService;
import bookmanager.dao.dbservice.UserService;
import bookmanager.model.po.BookInfoPO;
import bookmanager.model.po.BookLabelPO;
import bookmanager.model.po.PagePO;
import bookmanager.utilclass.BookUserMapUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

/**
 * Created by dela on 1/21/18.
 *
 * @Description: 登录后主页面对应的控制器
 */

@Controller
@RequestMapping("/auth")
public class MainController {
    private UserService userService;
    private BookInfoService bookInfoService;
    private BookLabelService bookLabelService;

    @Autowired
    public MainController(UserService userService, BookInfoService bookInfoService, BookLabelService bookLabelService) {
        this.userService = userService;
        this.bookInfoService = bookInfoService;
        this.bookLabelService = bookLabelService;
    }

    @RequestMapping(value = {"", "/", "/page/{currentPagePre}"}, method = RequestMethod.GET)
    public String getMainPage(Model model, @PathVariable(value = "currentPagePre", required = false) String currentPagePre,
                              @RequestParam(value = "tag", required = false) String labelIdPre) {
        int bookCount;
        List<BookInfoPO> bookInfoPOS;

        int currentPage = 1;
        if (currentPagePre != null) {
            currentPage = Integer.parseInt(currentPagePre);
        }
        PagePO pagePO = new PagePO(currentPage);

        int labelId = -1;
        if (labelIdPre != null) {
            labelId = Integer.parseInt(labelIdPre);
        }

        if (labelId == -1) {
            bookCount = bookInfoService.getBookCount();
        } else {
            bookCount = bookInfoService.getBookCountByLabelId(labelId);
        }
        pagePO.setTotalCount(bookCount);
        pagePO.setTotalPage((bookCount % 5 == 0) ? bookCount / 5 : bookCount / 5 + 1);

        List<BookLabelPO> bookLabelPOS = bookLabelService.getBookLabelByParentId(0);
        if (labelId == -1) {
            bookInfoPOS = bookInfoService.getBookByPage(pagePO);
        } else {
            bookInfoPOS = bookInfoService.getBookByLabelIdAndPage(pagePO, labelId);
        }

        // 将书籍信息中的uid对应成用户名
        Map<BookInfoPO, String> bookMap = BookUserMapUtil.getBookInfo(bookInfoPOS, userService);

        model.addAttribute("labels", bookLabelPOS);
        model.addAttribute("books", bookMap);
        model.addAttribute("pageInfo", pagePO);
        model.addAttribute("labelId", labelId);

        // 在这里添加分页的逻辑是因为JSP页面中EL表达式对逻辑运算的支持不太良好
        model.addAttribute("ELPageValue", (currentPage - 1) / 5 * 5);

        // 当总页数大于5时，需要如下属性
        if (pagePO.getTotalPage() >= 6) {
            model.addAttribute("isOneOfNextFivePage", (pagePO.getTotalPage() - 1) / 5 * 5 + 1);
            model.addAttribute("reachNextFivePage", (currentPage + 4) / 5 * 5 + 1);
        }

        // 当前页面大于等于6页的时候, 需要显示"[...]"按钮--返回到前一个5页
        if (currentPage >= 6) {
            model.addAttribute("returnPreFivePage", (currentPage - 1) / 5 * 5 - 4);
        }

        return "login";
    }
}
