import styles from "./Home.module.css"
import "../App.css"

/*모듈화를 통해 css를 만들면 class이름이 절대 겹치지않게 생성된다.*/
export default function Home() {
    return(
        <div>
            Home <button className={styles.button}>버튼1</button>
            <button className="button">버튼2</button>
        </div>
    )
}