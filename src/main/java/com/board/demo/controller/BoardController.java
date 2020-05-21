package com.board.demo.controller;

import com.board.demo.service.BoardService;
import com.board.demo.service.CategoryService;
import com.board.demo.service.ReplyService;
import com.board.demo.util.Conversion;
import com.board.demo.util.CurrentArticle;
import com.board.demo.vo.*;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static com.board.demo.util.Constants.*;

@Slf4j
@Controller
@RequestMapping("/board")
public class BoardController {
    private final String DEFAULT_CATEGORY = "전체보기";
    private final String DEFAULT_PAGE = "1";
    private final String DEFAULT_LIST_SIZE = "10";
    private final int NOT_EXIST = 0;

    @Autowired
    private BoardService boardService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ReplyService replyService;

    @GetMapping
    public ModelAndView showBoard(
            @RequestParam(defaultValue = DEFAULT_CATEGORY, required = false) String category,
            @RequestParam(defaultValue = DEFAULT_PAGE, required = false) Integer page,
            @RequestParam(defaultValue = DEFAULT_LIST_SIZE, required = false) Integer size) {
        ModelAndView mav = new ModelAndView();
        Page<Boardlist> boardlistPage = boardService.getList(category, page - 1, size);
        List<Boardlist> boards = boardlistPage.getContent();
        log.info("boards.size() : "+boards.size());

        if (boards.size() == NOT_EXIST) {
            return showErrorPage();
        }

        List<Category> categories = categoryService.getList();
        int totalPage = boardlistPage.getTotalPages();
        int startPage = Conversion.calcStartPage(page);

        Conversion.convertDateFormatForBoard(boards);
        Conversion.convertTitleLength(boards);

        mav.setViewName("board");
        mav.addObject("boards", boards);
        mav.addObject("categories", categories);
        mav.addObject("selectCategory", category);
        mav.addObject("selectSize", size);
        mav.addObject("curPage", page);
        mav.addObject("totalPage", totalPage);
        mav.addObject("startPage", startPage);
        return mav;
    }

    @GetMapping("/write")
    public ModelAndView showWriteForm(HttpServletRequest request) {
        ModelAndView mav = new ModelAndView();
        Member loginMember = (Member) request.getSession().getAttribute("loginMember");

        if (Objects.isNull(loginMember)) {
            mav.setViewName("redirect:/board");
        } else {
            List<Category> list = categoryService.getList();
            mav.setViewName("write_form");
            mav.addObject("categories", list);
        }
        return mav;
    }

    @PostMapping("/write")
    public void write(@RequestParam String title,
                      @RequestParam String content,
                      @RequestParam int category,
                      HttpServletRequest request,
                      HttpServletResponse response) throws IOException {
        JSONObject res = new JSONObject();
        Member loginMember = (Member) request.getSession().getAttribute("loginMember");

        if (Objects.isNull(loginMember)) {
            res.put(RESULT, INVALID_APPROACH);
        } else {
            boolean result = boardService.write(loginMember.getMemberId(), title, content, category);
            if (result) {
                res.put(RESULT, SUCCESS);
            } else {
                res.put(RESULT, FAIL);
            }
        }

        response.setContentType("application/json; charset=utf-8");
        response.getWriter().print(res);
    }

    @GetMapping("/{idx}")
    public ModelAndView viewPost(@PathVariable("idx") int boardId) {
        if (!boardService.addViews(boardId)) {
            return showErrorPage();
        }

        Boardlist article = boardService.getPostById(boardId);
        if (Objects.isNull(article)) {
            return showErrorPage();
        }
        CurrentArticle currentArticle = boardService.getPrevAndNextArticle(boardId);
        List<Replylist> replies = replyService.getRepliesByBoardId(boardId);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("view_article");
        mav.addObject("article", article);
        mav.addObject("replies", replies);
        mav.addObject("prev_article", currentArticle.getPrev());
        mav.addObject("next_article", currentArticle.getNext());
        return mav;
    }

    private ModelAndView showErrorPage() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("err_404");
        mav.addObject("err_msg", "요청하신 페이지를 찾을 수 없습니다.");
        return mav;
    }

}
